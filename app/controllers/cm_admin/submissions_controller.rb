class CMAdmin::SubmissionsController < ::InheritedResources::Base
  include CMAdmin::Controller
  before_filter :require_admin
  defaults :route_prefix => 'cm_admin'
  
  def unapproved
    @submissions = Submission.unapproved
    render 'index'
  end
  
  def featured
    @submissions = Submission.featured
    render 'index'
  end
  
  def index
    @submissions = Submission.all :order => 'approved_at DESC'
  end
end
