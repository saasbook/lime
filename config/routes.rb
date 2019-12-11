Rails.application.routes.draw do
  devise_for :resource_owners
  devise_for :posts
  devise_for :users, controllers: {registrations: 'users/registrations'}
  resources :bug_reports
  get 'faq/index'
  get 'welcome/index'
  get 'resources/unapproved', to: 'resources#unapproved'
  get 'resources/archived', to: 'resources#archived'
  get 'resources/flagged', to: 'resources#flagged'
  get 'resources/all', to: 'resources#all'
  get 'resources/:email/edit', to: 'resources#owner_edit', as: "owner_edit_resource",  constraints: { email: /.+@.+\..*/ }
  post 'resources/:id/confirm', to: 'resources#confirm', as: "confirm"
  # If a 'display user information' page gets added, may be good idea to move location
  # of flash key button to that page.
  devise_scope :user do
    get 'user/showkey', to: 'users/registrations#showkey', as: 'showkey_user'
  end
  resources :resources, :defaults => {:format => 'json'}

  match 'resources/approve/many' => 'resources#approve_many', via: [:put, :patch, :post], :defaults => {:format => 'json'}
  match 'resources/archive/many' => 'resources#archive_many', via: [:put, :patch, :post], :defaults => {:format => 'json'}
  match 'resources/delete/many' => 'resources#delete_many', via: [:delete], :defaults => {:format => 'json'}

  match 'resources/approve/:id' => 'resources#update', via: [:put, :patch, :post], :defaults => {:format => 'json'}
  match 'resources/archive/:id' => 'resources#archive', as: :resources_archive, via: [:put, :post, :patch]
  match 'resources/restore/:id' => 'resources#restore', as: :resources_restore, via: [:put, :post, :patch]
  match 'resources/flag/:id' => 'resources#flag', as: :resources_flag, via: [:put, :post, :patch]

  match 'resources/unapproved' => 'resources#upload', via: [:put, :patch, :post], :defaults => {:format => 'json'}
  root "welcome#index"
  #For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
