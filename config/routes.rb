Rails.application.routes.draw do

  resources :resources, :defaults => {:format => 'json'}


  post '/resources(.:format)', to: 'resources#create', as: 'create_resource'
  put '/resources(.:format)', to: 'resources#update', as: 'update_attributes'
  #For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
