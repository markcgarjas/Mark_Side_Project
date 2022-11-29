Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  constraints(ClientDomainConstraint.new) do
    root to: 'home#index'
    devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
    resources :home
  end

  constraints(AdminDomainConstraint.new) do
    namespace :admin, path: '' do
      root to: 'home#index'
      devise_for :users, controllers: { sessions: 'admins/sessions' }
      resources :users
      resources :home
    end
  end
end
