class CMAdmin::SubmissionsController < ::InheritedResources::Base
  include CMAdmin::Controller
  before_filter :require_admin
  actions :index, :edit, :update, :destroy
end
