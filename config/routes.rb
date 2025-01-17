Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  root 'articles#index'
  resources :users, only: %i[new create edit update]
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  resources :tags, only: %i[show]
  resources :bookmarks, only: %i[create destroy]
  get 'mypage', to: 'users#mypage', as: 'mypage'

  resources :articles, only: %i[index new create show edit update destroy] do
    resources :comments, only: %i[create edit update destroy]
    resource :favorites, only: %i[create destroy]
    get :tags, on: :collection
    collection do
      get :bookmarks
    end
  end

  match '*unmatched_route', to: 'errors#routing_error', via: :all
end
