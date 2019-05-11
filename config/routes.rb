Rails.application.routes.draw do
  resources :bug_reports
  get 'faq/index'
  get 'welcome/index'
  get 'resources/unapproved', to: 'resources#unapproved'
  resources :resources, :defaults => {:format => 'json'}
  match 'resources/approve/many' => 'resources#approve_many', via: [:put, :patch, :post], :defaults => {:format => 'json'}
  match 'resources/approve/:id' => 'resources#update', via: [:put, :patch, :post], :defaults => {:format => 'json'}
  root "welcome#index"
  devise_for :users, controllers: {registrations: 'users/registrations'}
  #For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
