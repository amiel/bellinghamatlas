module CMAdmin
  class DashboardsController < ApplicationController
    include CMAdmin::Controller
    before_filter :require_admin
    
    def show
      
    end
  end
end