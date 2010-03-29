class Submission < ActiveRecord::Base
  acts_as_mappable
  is_gravtastic!
  before_validation :geocode_address
  
  validates_presence_of :name
  validates_presence_of :title
  
  named_scope :approved, :conditions => 'approved_at IS NOT NULL'
  named_scope :unapproved, :conditions => 'approved_at IS NULL'
  named_scope :featured, :conditions => { :featured => true }
  named_scope :recent, :order => 'approved_at DESC'
  
  validates_presence_of :address, :if => proc{|s| s.lat.blank? or s.lng.blank? }
  validates_presence_of :lat, :if => proc{|s| s.address.blank? }
  validates_presence_of :lng, :if => proc{|s| s.address.blank? }
  
  def self.random_featured
    featured.first :offset => rand(featured.count)
  end


  def self.paperclip_storage
    if ENV['S3_ACCESS_KEY_ID'] and ENV['S3_SECRET_ACCESS_KEY'] then
      {
        :storage => :s3,
        :s3_credentials => { :access_key_id => ENV['S3_ACCESS_KEY_ID'], :secret_access_key => ENV['S3_SECRET_ACCESS_KEY'] },
        :path => ":attachment/:id/:style.:extension",
        :bucket => "bellinghamatlas-#{Rails.env}"
      }
    else
      {}
    end
  end
  
  has_attached_file(:photo, {
    :default_style => :small,
    :styles => {
      :icon => '43x43#',
      :thumb => '90x67#',
      :medium_cropped => '272x163#',
      :medium => '272x163>',
      :large => '600x400>'
    }
  }.merge(paperclip_storage))
  

  def media_color
    {
      :photo => 'green',
      :video => 'red',
      :none => 'blue',
    }[media_type]
  end

  def media_type
    photo? ? :photo : youtube? ? :video : :none
  end

  def reset_video_info!
    @video_info = nil
  end

  def video_info
    @video_info ||= VideoInfo.new video_url
  end

  def video?
    video_info.valid?
  end
  
  def youtube_video_id
    video_info.video_id
  end

  def youtube?
    video? && video_info.provider == 'YouTube'
  end

  def approve!
    update_attribute :approved_at, Time.current
  end
  
  def approved=(v)
    if ActiveRecord::ConnectionAdapters::Column.value_to_boolean v
      approve! unless approved?
    else
      update_attribute :approved_at, nil
    end
  end
  
  def approved
    !!approved_at
  end
  alias_method :approved?, :approved

  private
  def geocode_address
    if self.address_changed? and !self.address.blank? then
      self.address = "#{self.address}, Bellingham, WA" unless self.address.match /Bellingham,?\s+WA/i
    
      geo = Geokit::Geocoders::MultiGeocoder.geocode(address)
      self.lat, self.lng = geo.lat, geo.lng if geo.success

      errors.add(:address, I18n.t(:'activerecord.errors.geocode')) if lat.blank? or lng.blank?
    end
  end
end
