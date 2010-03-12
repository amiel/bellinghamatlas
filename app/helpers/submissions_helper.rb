module SubmissionsHelper
  
  def map_javascripts map = @map
    @submissions.each do |s|
  	  @map.overlay_init(GMarker.new([s.lat, s.lng], :title => s.name, :info_window => render(:partial => 'info_window', :locals => {:s => s})))
  	end
	end
end
