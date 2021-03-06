require 'sidekiq/web'
Rails.application.routes.draw do

  root to: "pages#welcome"
  mount Sidekiq::Web, at: '/sidekiq'
  mount StripeEvent::Engine => '/stripe_events'

  get 'ui(/:action)', controller: 'ui'
  get '/signin', to: 'sessions#new'
  post '/signin', to: 'sessions#create'
  get '/signout', to: 'sessions#destroy'

  resources :videos, only: [:index, :show] do
    resources :reviews, only: [:create]
  end

  namespace :admin do
    resources :videos, only: [:new, :create]
    get '/lazy', to: "videos#lazy" #justforfun
    post '/lazy_add', to: "videos#lazy_add" #justforfun
    resources :payments, only: [:index]
  end

  resources :categories, only: [:index, :show, :edit]
  resources :users, only: [:show, :create]
  get '/register', to: "users#new"
  get '/register/:token', to: "users#new_with_invite", as: "register_with_token"

  get 'search', to: 'search#index'


  resources :queue_items, only: [:create, :destroy]
  get '/my_queue', to: "queue_items#index"
  post "update_queue", to: "queue_items#update_queue"

  resources :relationships, only: [:show, :create, :destroy]
  get "following_people", to: "users#following"

  get '/forgot_password', to: "forgot_password#new"
  post '/forgot_password', to: "forgot_password#create"

  get '/password_reset', to: "password_reset#show"
  post '/password_reset', to: "password_reset#create"

  get '/invalid_token', to: "pages#invalid_token"

  resources :invitations, only: [:new, :create]

  resources :payments, only: [:show]
end
