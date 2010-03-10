ActionController::Routing::Routes.draw do |map|
  SprocketsApplication.routes(map)
  map.resources :submissions

  map.namespace :cm_admin, :path_prefix => 'admin' do |admin|
    admin.resources :submissions
  end

  map.root :controller => 'submissions'

end
