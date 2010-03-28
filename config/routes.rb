ActionController::Routing::Routes.draw do |map|
  map.connect "meta", :controller => "meta", :action => "index"
  map.resources :movies
end
