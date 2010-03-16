class Submission < ActiveRecord::Base
  acts_as_mappable
  is_gravtastic!
  before_validation :geocode_address
  
  validates_presence_of :name
  
  has_attached_file :photo, {
    :default_style => :small,
    :styles => {
      :icon => '32x32#',
      :thumb => '64x64#',
      :small => '120x80>',
    },
    :storage => :s3,
    :s3_credentials => { :access_key_id => ENV['S3_ACCESS_KEY_ID'], :secret_access_key => ENV['S3_SECRET_ACCESS_KEY'] },
    :path => ":attachment/:id/:style.:extension",
    :bucket => "bellinghamatlas-#{Rails.env}"
  }
  
  named_scope :approved, :conditions => 'approved_at IS NOT NULL'
  named_scope :unapproved, :conditions => 'approved_at IS NULL'

  def video?
    !!video_url
  end
  
  def youtube_video_id
    @youtube_video_id = begin
      matches = self.video_url.match(/youtube\.com\/watch.v=(\w+)/)
      matches[1] unless matches.nil?
    end unless defined? @youtube_video_id
  end

  def youtube?
    !!youtube_video_id
  end

  def approve!
    update_attribute :approved_at, Time.current
  end
  
  def approved=(v)
    if ActiveRecord::ConnectionAdapters::Column.value_to_boolean v
      approve!
    else
      update_attribute :approved_at, false
    end
  end
  
  def approved
    !!approved_at
  end
  alias_method :approved?, :approved

  private
  def geocode_address
    if self.address_changed? then
      self.address = "#{self.address}, Bellingham, WA" unless self.address.match /Bellingham,?\s+WA/i
    
      geo = Geokit::Geocoders::MultiGeocoder.geocode(address)
      self.lat, self.lng = geo.lat, geo.lng if geo.success

      errors.add(:address, I18n.t(:'activerecord.errors.geocode')) if lat.blank? or lng.blank?
    end
  end
end
