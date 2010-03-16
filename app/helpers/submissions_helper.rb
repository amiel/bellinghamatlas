module SubmissionsHelper
  
  def map_javascripts map = @map
    @submissions.each do |s|
  	  @map.overlay_init(GMarker.new([s.lat, s.lng], :title => s.name, :info_window => render(:partial => 'info_window', :locals => {:s => s})))
  	end
	end
	
	VIDEO_SIZES = {
    :icon =>  { :height => 43, :width => 43 },
    :thumb => { :height => 67, :width => 90 },
    :medium_cropped => { :height => 163, :width => 272 },
	}
	
	def media_for submission, size = :icon
    case submission.try :media_type
    when :photo
      image_tag submission.photo.url(size)
    when :video
      dimensions = VIDEO_SIZES[size]
      case size
      when :medium_cropped : youtube_video(submission.youtube_video_id, dimensions)
      when :thumb : youtube_thumb(submission.youtube_video_id, dimensions)
      else ''
      end
    else
      ''
    end
	end
	
	def youtube_thumb video_id, dimensions
	  image_tag "http://i.ytimg.com/vi/#{video_id}/1.jpg", dimensions
	end
	
  def youtube_video video_id, options = {}
    options[:width]  ||= 480
    options[:height] ||= 295
    
    <<-HTML
      <object width="#{options[:width]}" height="#{options[:height]}">
        <param name="movie" value="http://www.youtube.com/v/#{video_id}&hl=en_US&fs=1&"></param>
        <param name="allowFullScreen" value="true"></param>
        <param name="allowscriptaccess" value="always"></param>
        <embed src="http://www.youtube.com/v/#{video_id}&hl=en_US&fs=1&" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="#{options[:width]}" height="#{options[:height]}"></embed>
      </object>
    HTML
	end
	
end
