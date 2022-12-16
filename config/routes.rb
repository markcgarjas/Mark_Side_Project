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
      resources :lottery, only: [:index, :show, :create]
      resources :shop
      resources :claim
    end
  end

  constraints(AdminDomainConstraint.new) do
    namespace :admins, path: '' do
      root "home#index"
      resources :home
      devise_for :users, controllers: { sessions: 'admins/sessions' }
      resources :users, index: :only
      resources :items do
        put 'start_event', to: 'items#start_event'
        put 'end_event', to: 'items#end_event'
        put 'cancel_event', to: 'items#cancel_event'
        put 'pause_event', to: 'items#pause_event'
      end
      resources :categories
      resources :bets do
        put 'cancel_bet', to: 'bets#cancel_bet'
      end
      resources :winners do
        put 'submit_event', to: 'items#submit_event'
        put 'pay_event', to: 'items#pay_event'
        put 'ship_event', to: 'items#ship_event'
        put 'deliver_event', to: 'items#deliver_event'
        put 'publish_event', to: 'items#publish_event'
        put 'remove_publish_event', to: 'items#remove_publish_event'
      end
      resources :offers
      resources :orders do
        put 'pay_event', to: 'orders#pay_event'
        put 'cancel_event', to: 'orders#cancel_event'
      end
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
