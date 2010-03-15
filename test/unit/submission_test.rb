require 'test_helper'

class SubmissionTest < ActiveSupport::TestCase
  context 'a new submission' do
    setup { @submission = Factory(:submission) }
    subject { @submission }
    
    should_validate_presence_of :name
    
    should 'set geocode the address' do
      @submission.address = '104 State st'
      assert @submission.save, 'expected save'
      assert @submission.lat, 'expected lat'
      assert @submission.lng, 'expected lng'
    end
  end

end
