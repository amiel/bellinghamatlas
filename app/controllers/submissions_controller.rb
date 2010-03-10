class SubmissionsController < ::InheritedResources::Base
  def index
    @submissions = Submission.approved
  end
  # 
  # def new
  # end

end
