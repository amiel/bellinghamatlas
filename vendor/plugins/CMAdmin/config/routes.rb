ActionController::Routing::Routes.draw do |map|
  map.resources :pages, :controller => 'spreadhead/pages', :path_prefix => 'admin'
  
  map.namespace :cm_admin, :path_prefix => 'admin' do |admin|
    admin.signup 'signup', :controller => 'admins', :action => 'create', :conditions => { :method => :post }
    admin.signup 'signup', :controller => 'admins', :action => 'new', :conditions => { :method => :get }    
    admin.resource :account, :controller => 'admins'

    admin.login  'login',  :controller => 'admin_sessions', :action => 'create', :conditions => { :method => :post }
    admin.login  'login',  :controller => 'admin_sessions', :action => 'new', :conditions => { :method => :get }
    admin.logout 'logout', :controller => 'admin_sessions', :action => 'destroy'
    admin.resources :password_resets, :only => [ :new, :create, :edit, :update ]
    
    
    admin.root :controller => :dashboards
    admin.resource :dashboard
  end
end