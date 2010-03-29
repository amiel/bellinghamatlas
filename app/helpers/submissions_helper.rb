module SubmissionsHelper
  
  def map_javascripts map = @map
    @submissions.each do |s|
  	  @map.overlay_init(GMarker.new([s.lat, s.lng], :title => s.name, :info_window => render(:partial => 'info_window', :locals => {:s => s})))
  	end
	end
	
	def link_to_submission_modal s, text = s.title
    link_to_function text, "show_large(#{large_submission_path(s, :format => 'partial').to_json}, #{text.to_json}, #{s.gravatar_url(:size => 16).to_json})"
	end
	
	VIDEO_SIZES = {
    :icon =>  { :height => 43, :width => 43 },
    :thumb => { :height => 67, :width => 90 },
    :medium_cropped => { :height => 163, :width => 272 },
    :medium => { :height => 163, :width => 272 },
    :large => { :height => 400, :width => 600 }
	}
	
	def icon_for submission
    image_tag "#{submission.media_color}_marker.png", :alt => submission.media_type
	end
	
	def media_for submission, size = :icon
    case submission.try :media_type
    when :photo
      img = image_tag submission.photo.url(size)
      case size
      when :medium, :medium_cropped : link_to(img, submission.photo.url(:original))
      else img
      end
    when :video
      dimensions = VIDEO_SIZES[size]
      case size
      when :medium_cropped, :medium, :large : youtube_video(submission.youtube_video_id, dimensions)
      when :thumb : youtube_thumb(submission, dimensions)
      else ''
      end
    else
      ''
    end
	end
	
	def youtube_thumb submission, dimensions
	  image_tag submission.video_info.thumbnail_small, dimensions.merge(:alt => 'video still')
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
