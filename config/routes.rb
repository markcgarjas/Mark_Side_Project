Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  constraints(ClientDomainConstraint.new) do

    devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
    namespace :users, path: '' do
      root "homes#index"
      resource :home
      resource :profile, show: :only do
        resources :addresses
      end
      resources :invite_people, only: :index
    end
  end

  constraints(AdminDomainConstraint.new) do
    namespace :admins, path: '' do
      root "home#index"
      resources :home
      devise_for :users, controllers: { sessions: 'admins/sessions' }
      resources :users, index: :only
      resources :items
      resources :categories
    end
  end

  namespace :api do
    resources :regions, only: :index, defaults: { format: :json } do
      resources :provinces, only: :index, defaults: { format: :json } do
        resources :city_municipalities, only: :index, defaults: { format: :json } do
          resources :barangays, only: :index, defaults: { format: :json }
        end
      end
    end
  end
end
