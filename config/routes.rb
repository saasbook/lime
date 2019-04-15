Rails.application.routes.draw do

  devise_for :users
  resources :resources, :defaults => {:format => 'json'}


  post '/resources(.:format)', to: 'resources#create', as: 'create_resource'
  #For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
