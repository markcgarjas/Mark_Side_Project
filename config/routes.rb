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
        put 'cancel_event/:id', as: :cancel_event, to: 'profiles#cancel_event'
        resources :addresses
      end
      resources :invite_people, only: :index
      resources :lottery, only: [:index, :show, :create]
      resources :shop
      resources :claim
      resources :feedback
      resources :share
    end
  end

  constraints(AdminDomainConstraint.new) do
    namespace :admins, path: '' do
      root "home#index"
      resources :home
      devise_for :users, controllers: { sessions: 'admins/sessions' }
      resources :users, path: "users/clients" do
        get 'orders/:genre/new', as: :new, to: 'orders#new'
        post 'orders/:genre', as: :create, to: 'orders#create'
      end
      resources :items do
        put 'start_event', to: 'items#start_event'
        put 'end_event', to: 'items#end_event'
        put 'cancel_event', to: 'items#cancel_event'
        put 'pause_event', to: 'items#pause_event'
      end
      resources :categories, except: :show
      resources :bets, only: :index do
        put 'cancel_bet', to: 'bets#cancel_bet'
      end
      resources :winners, only: :index do
        put 'submit_event', to: 'winners#submit_event'
        put 'pay_event', to: 'winners#pay_event'
        put 'ship_event', to: 'winners#ship_event'
        put 'deliver_event', to: 'winners#deliver_event'
        put 'publish_event', to: 'winners#publish_event'
        put 'remove_publish_event', to: 'winners#remove_publish_event'
      end
      resources :offers
      resources :orders do
        put 'pay_event', to: 'orders#pay_event'
        put 'cancel_event', to: 'orders#cancel_event'
      end
      resources :invites, only: :index
      resources :news_tickers
      resources :banners
      resources :member_levels
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
