Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  constraints(ClientDomainConstraint.new) do
    root to: 'homes#index'
    devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
    resources :homes
    resource :me do
      resources :addresses
    end
  end

  constraints(AdminDomainConstraint.new) do
    namespace :admin, path: '' do
      root to: 'home#index'
      devise_for :users, controllers: { sessions: 'admins/sessions' }
      resources :users
      resources :home
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
