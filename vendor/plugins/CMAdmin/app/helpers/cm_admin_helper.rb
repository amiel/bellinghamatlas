module CMAdminHelper
  def admin_tab(label, path, options = {})
    (options[:class] ||= '') << ' current' if current_page? path
    
    content_tag :li, link_to(I18n.t(:"cm_admin.navigation.#{label}", :default => label.to_s.titleize), path), options
  end
end

CmAdminHelper = CMAdminHelper unless defined? CmAdminHelper