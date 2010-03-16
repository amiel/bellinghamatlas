require 'test_helper'

class SubmissionTest < ActiveSupport::TestCase
  context 'a submission' do
    setup { @submission = Factory(:submission) }
    subject { @submission }
    
    should_validate_presence_of :name
    
    should 'respond none for media_type' do
      assert_equal :none, @submission.media_type
    end
    
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
    
    context 'with a fake photo' do
      setup { @submission.stubs(:photo?).returns(true) }
      
      should 'respond with true for photo?' do
        assert @submission.photo?
      end
      
      should 'respond with photo for media_type' do
        assert_equal :photo, @submission.media_type
      end
    end
    
    context 'with a blank video_url' do
      setup { @submission.update_attribute :video_url, '' }
      
      should 'return false for video?' do
        assert !@submission.video?
      end
    end
    
    context 'with an address that already ends with bellingham' do
      setup { @submission.update_attributes :address => '104 State st, Bellingham, WA' } # carnes media
      
      should 'not append Bellingham, WA to the address' do
        assert_no_match(/Bellingham.*Bellingham,?\s+WA$/i, @submission.address)
      end
    end
    
    context 'with a youtube video' do
      setup { @submission.update_attribute :video_url, 'http://www.youtube.com/watch?v=jv04EdNJxKM' }
      
      should 'return video for media_type' do
        assert_equal :video, @submission.media_type
      end
      
      should 'return true for video?' do
        assert @submission.video?
      end
      
      should 'return true for youtube?' do
        assert @submission.youtube?
      end
      
      should 'return the youtube_video_id' do
        assert_equal 'jv04EdNJxKM', @submission.youtube_video_id
      end
      
      should 'return the youtube_video_id on the second call' do
        assert_equal 'jv04EdNJxKM', @submission.youtube_video_id, 'expceted first call to work'
        assert_equal 'jv04EdNJxKM', @submission.youtube_video_id, 'expected second call to work'
      end
    end
    
    context 'with another video' do
      setup { @submission.update_attribute :video_url, 'http://vimeo.com/groups/afx/videos/10173334' }
      
      should 'return true for video?' do
        assert @submission.video?
      end
      
      should 'return false for youtube?' do
        assert !@submission.youtube?
      end
      
      should 'return none for media_type (for now)' do
        assert_equal :none, @submission.media_type
      end
    end
  end

end
