ActionController::Routing::Routes.draw do |map|
  SprocketsApplication.routes(map)
  map.resources :submissions

  map.root :controller => 'submissions'

end
