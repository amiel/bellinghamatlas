module CMAdmin
  class PasswordResetsController < ApplicationController
    include CMAdmin::Controller
    before_filter :require_no_admin
    before_filter :load_admin_using_perishable_token, :only => [ :edit, :update ]
    

    def new
      @admin = Admin.new
    end

    def create
      @admin = Admin.find_by_email(params[:admin][:email])
      if @admin
        @admin.deliver_password_reset_instructions!
        
        flash[:notice] = I18n.t(:'flashes.cm_admin.password_resets.create.notice')
        redirect_to cm_admin_login_path
      else
        @admin = Admin.new
        flash[:error] = I18n.t(:'flashes.cm_admin.password_resets.create.error')
        render :action => :new
      end
    end

    def edit
    end

    def update
      @admin.password = params[:admin][:password]
      @admin.password_confirmation = params[:admin][:password_confirmation]
      if @admin.save then
        flash[:success] = I18n.t(:'flashes.cm_admin.password_resets.update.notice')
        redirect_to cm_admin_login_path
      else
        render :action => :edit
      end
    end


    private

    def load_admin_using_perishable_token
      @admin = Admin.find_using_perishable_token(params[:id])
      unless @admin
        flash[:error] = I18n.t(:'flashes.cm_admin.password_resets.not_found')

        redirect_to root_url
      end
    end
  end
end