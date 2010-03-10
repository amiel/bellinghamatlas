module CMAdmin
  class AdminsController < ApplicationController
    include CMAdmin::Controller
    before_filter :allow_only_first_admin, :only => [:new, :create]
    before_filter :require_admin, :only => [:show, :edit, :update, :destroy]
    
    def show
      @admin = @current_admin
    end

    def new
      @admin = Admin.new
    end

    def create
      @admin = Admin.new(params[:admin])
      if @admin.save
        flash[:notice] = I18n.t(:'flashes.cm_admin.admins.create.notice')
        redirect_back_or_default cm_admin_account_url
      else
        render :action => :new
      end
    end
    
    def edit
      @admin = @current_admin
    end

    def update
      @admin = @current_admin # makes our views "cleaner" and more consistent
      if @admin.update_attributes(params[:admin])
        flash[:notice] = I18n.t(:'flashes.cm_admin.admins.update.notice')
        redirect_to cm_admin_account_url
      else
        render :action => :edit
      end
    end

    def destroy
      @admin = @current_admin
      @admin.destroy
    
      flash[:notice] = I18n.t(:'flashes.cm_admin.admins.destroy.notice')
      redirect_to root_path
    end
  
    private
    def allow_only_first_admin
      Admin.first ? require_admin : require_no_admin
    end
  
  end
end