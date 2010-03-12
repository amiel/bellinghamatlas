class SubmissionsController < ::InheritedResources::Base
  def index
    @submissions = Submission.approved
    setup_map

    @submissions.each do |s|
      @map.overlay_init(GMarker.new([s.lat, s.lng], :title => s.name, :info_window => "<h3>#{s.name}</h3><p>#{s.address}</p>"))
    end
  end

  
  def show
    @submission = Submission.find params[:id]
    setup_map
    @map.overlay_init(GMarker.new([@submission.lat, @submission.lng], :title => @submission.name, :info_window => "<h3>#{@submission.name}</h3><p>#{@submission.address}</p>"))
  end


  private
  def setup_map
    @map = GMap.new('map')
    # @map.control_init(:small_map => true)
    @map.record_init(@map.add_control(GSmallMapControl.new, GControlPosition.new(:top_left, 'new GSize(10, 50)')))
    @map.set_map_type_init(GMapType::G_PHYSICAL_MAP)
    @map.center_zoom_init([48.7597000, -122.4869000], 13)
  end
end
