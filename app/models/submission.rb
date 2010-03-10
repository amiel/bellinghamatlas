class Submission < ActiveRecord::Base
  acts_as_mappable
  before_validation_on_create :geocode_address

  named_scope :approved, :conditions => 'approved_at IS NOT NULL'

  def approve!
    update_attribute :approved_at, Time.current
  end

  private
  def geocode_address
    
    self.address = "#{self.address} Bellingham, WA"
    
    geo = Geokit::Geocoders::MultiGeocoder.geocode(address)
    self.lat, self.lng = geo.lat, geo.lng if geo.success

    errors.add(:address, I18n.t(:'activerecord.errors.geocode')) if lat.blank? or lng.blank?
  end
end
