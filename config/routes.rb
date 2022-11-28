Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  constraints(ClientDomainConstraint.new) do
    root to: 'home#index'
    devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
  end

  constraints(AdminDomainConstraint.new) do
    namespace :admins, path: '' do
      root to: 'home#index'
      devise_for :users, controllers: { sessions: 'admins/sessions' }
    end
  end
end
