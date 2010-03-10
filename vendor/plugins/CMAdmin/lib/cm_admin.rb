
module CMAdmin
  
  module Controller
    def self.included(base)
      base.send :include, CMAdmin::AuthenticationHandling
      base.send :helper, :cm_admin
      base.send :layout, 'cm_admin'
    end
  end
  
  
  module AuthenticationHandling

    def self.included(base)
      base.send(:filter_parameter_logging, :password, :password_confirmation)
      base.send(:helper_method, :current_admin_session, :current_admin)
    end

  private

    def current_admin_session
      @current_admin_session ||= AdminSession.find
    end

    def current_admin
      @current_admin ||= current_admin_session && current_admin_session.admin
    end

    def require_admin
      unless current_admin
        store_location
        flash[:notice] = I18n.t(:'flashes.cm_admin.admins.must_be_logged_in')
        redirect_to cm_admin_login_url
        return false
      end
    end

    def require_no_admin
      if current_admin
        store_location
        flash[:notice] = I18n.t(:'flashes.cm_admin.admins.must_be_logged_out')
        redirect_to cm_admin_account_url
        return false
      end
    end

    def store_location
      session[:return_to] = request.request_uri
    end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

  end
end

CmAdmin = CMAdmin