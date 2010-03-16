class CMAdmin::SubmissionsController < ::InheritedResources::Base
  include CMAdmin::Controller
  before_filter :require_admin
  defaults :route_prefix => 'cm_admin'
  actions :index, :edit, :update, :destroy
  
  def index
    @submissions = Submission.unapproved
  end

  def show
    redirect_to :action => :index
  end
  
end
