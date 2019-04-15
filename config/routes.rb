Rails.application.routes.draw do

  devise_for :users, controllers: {registrations: 'users/registrations'}
  resources :resources, :defaults => {:format => 'json'}
  root :to => "resources#index", :format => 'html'
  match 'resources/approve/many' => 'resources#approve_many', via: [:put, :patch, :post], :defaults => {:format => 'json'}
  match 'resources/approve/:id' => 'resources#approve_many', via: [:put, :patch, :post], :defaults => {:format => 'json'}
  #For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
