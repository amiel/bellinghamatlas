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
      # setup { @submission.update_attributes :address => '104 State st', :lat => 48.74617, :lng => -122.481017 }
      setup { @submission.update_attributes :lat => 48.0, :lng => -122.0 } # purposely wrong lat/lng
      
      should 'not geocode the address again' do
        assert_equal 48.0, @submission.lat
        assert_equal -122.0, @submission.lng
      end
    end
  end

end
