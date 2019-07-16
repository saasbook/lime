Rails.application.routes.draw do
  devise_for :users
  resources :bug_reports
  get 'faq/index'
  get 'welcome/index'
  get 'resources/unapproved', to: 'resources#unapproved'
  # If a 'display user information' page gets added, may be good idea to move location
  # of flash key button to that page.
  devise_scope :user do
    get 'user/showkey', to: 'users/registrations#showkey', as: 'showkey_user'
  end
  resources :resources, :defaults => {:format => 'json'}
  match 'resources/approve/many' => 'resources#approve_many', via: [:put, :patch, :post], :defaults => {:format => 'json'}
  match 'resources/approve/:id' => 'resources#update', via: [:put, :patch, :post], :defaults => {:format => 'json'}
  root "welcome#index"
  #For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
