ActionController::Routing::Routes.draw do |map|
  SprocketsApplication.routes(map)
  map.resources :submissions, :member => { :info_window => :get, :large => :get }

  map.namespace :cm_admin, :path_prefix => 'admin' do |admin|
    admin.resources :submissions, :collection => { :featured => :get, :unapproved => :get }
  end

  # map.root :controller => 'submissions' # this will be the root
  map.root :controller => 'submissions', :action => 'new'

end
