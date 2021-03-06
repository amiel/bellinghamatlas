class SubmissionsController < ::InheritedResources::Base
  
  before_filter :need_submissions_session, :only => [ :show, :create, :edit, :update, :new ] 
  before_filter :require_submission_from_current_session, :only => [:show, :edit, :update ]
  
  def index
    @submissions = Submission.recent.approved
    @featured_submission = Submission.random_featured
    setup_map
    
    @goldi_has_spoken = session[:goldi_has_spoken]
    session[:goldi_has_spoken] = true
    
		render :layout => "map"
  end
  
  def info_window
    @submission = Submission.approved.find params[:id]
  end
  
  def large
    @submission = Submission.approved.find params[:id]
  end
  
  
  def show
    @submission = Submission.find params[:id]
    setup_map
    @map.overlay_init(GMarker.new([@submission.lat, @submission.lng], :title => @submission.name))
  end
  
  def create
    create! do
      if @submission.errors.empty? then
        session[:submission_ids] << @submission.id
      end
      @submission
    end
  end


  private
  def need_submissions_session
    session[:submission_ids] ||= []
    @saved_submissions = Submission.find session[:submission_ids]
  rescue ActiveRecord::RecordNotFound => e
    session[:submission_ids] = @saved_submissions = []
  end
  
  def require_submission_from_current_session
    redirect_to root_path unless session[:submission_ids].include?(params[:id].to_i)
  end
  
  def setup_map
    @map = GMap.new('map')
    # @map.record_init(@map.add_control(GSmallMapControl.new, GControlPosition.new(:top_left, 'new GSize(10, 50)')))
    #  @map.set_map_type_init(GMapType::G_PHYSICAL_MAP)
    #  @map.center_zoom_init([48.7597000, -122.4869000], 13)
  end
end
