require 'test_helper'

class SubmissionTest < ActiveSupport::TestCase
  context 'a new submission' do
    setup { @submission = Factory(:submission) }
    subject { @submission }
    
    should_validate_presence_of :name
    
    should 'geocode the address' do
      @submission.address = '104 State st'
      assert @submission.save, 'expected save'
      assert @submission.lat, 'expected lat'
      assert @submission.lng, 'expected lng'
    end
    
    context 'with an address and a lat lng' do
      setup { @submission.update_attributes :address => '104 State st', :lat => 48.74617, :lng => -122.481017 } # carnes media
      
      should 'not geocode the address again' do
        @submission.lat = 48.0
        @submission.lng = -122.0
        @submission.save
        assert_equal 48.0, @submission.lat
        assert_equal -122.0, @submission.lng
      end
      
      should 'geocode the address if it changes' do
        old_lat = @submission.lat
        old_lng = @submission.lng
        @submission.address = '1323 Railroad Avenue' # malladrs
        assert @submission.save
        assert @submission.lat != old_lat, 'expected lat to change'
        assert @submission.lng != old_lng, 'expected lng to change'
      end
      
      should 'append Bellingham, WA to address' do
        assert_match(/,?\s+Bellingham,?\s+WA$/i, @submission.address)
      end
    end
    
    context 'with an address that already ends with bellingham' do
      setup { @submission.update_attributes :address => '104 State st, Bellingham, WA' } # carnes media
      
      should 'not append Bellingham, WA to the address' do
        assert_no_match(/Bellingham.*Bellingham,?\s+WA$/i, @submission.address)
      end
    end
  end

end
