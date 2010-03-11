class Submission < ActiveRecord::Base
  acts_as_mappable
  before_validation_on_create :geocode_address
  
  validates_presence_of :name
  validates_presence_of :text
  
  has_attached_file :photo, {
    :storage => :s3,
    :s3_credentials => { :access_key_id => ENV['S3_ACCESS_KEY_ID'], :secret_access_key => ENV['S3_SECRET_ACCESS_KEY'] },
    :path => ":attachment/:id/:style.:extension",
    :bucket => "bellinghamatlas-#{Rails.env}"
  }
  named_scope :approved, :conditions => 'approved_at IS NOT NULL'

  def approve!
    update_attribute :approved_at, Time.current
  end
  
  def approved=(v)
    approve! if ActiveRecord::ConnectionAdapters::Column.value_to_boolean v
  end
  
  def approved
    !!approved_at
  end

  private
  def geocode_address
    
    self.address = "#{self.address} Bellingham, WA"
    
    geo = Geokit::Geocoders::MultiGeocoder.geocode(address)
    self.lat, self.lng = geo.lat, geo.lng if geo.success

    errors.add(:address, I18n.t(:'activerecord.errors.geocode')) if lat.blank? or lng.blank?
  end
end
