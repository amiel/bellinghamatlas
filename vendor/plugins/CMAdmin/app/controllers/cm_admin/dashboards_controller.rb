module CMAdmin
  class DashboardsController < ApplicationController
    include CMAdmin::Controller
    before_filter :require_admin
    
    def index
      redirect_to :action => :show
    end
    
    def show
      
    end
  end
end