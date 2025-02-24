Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
  root 'articles#index'
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  resources :bookmarks, only: %i[create destroy]
  get 'mypage', to: 'users#mypage', as: 'mypage'
  resources :password_resets, only: %i[new create edit update]
  resources :users, only: %i[new create show edit update]
  resources :tags, only: %i[show]
  get 'policy', to: 'pages#policy'
  get 'terms', to: 'pages#terms'

  resources :articles, only: %i[index new create show edit update destroy] do
    resources :comments, only: %i[create edit update destroy]
    resource :favorites, only: %i[create destroy]
    get :tags, on: :collection
    collection do
      get :bookmarks
      get :autocomplete_title
      get :autocomplete_user_name
      get :autocomplete_tags_name
    end
  end

  match '*unmatched_route', to: 'errors#routing_error', via: :all, constraints: lambda { |req| !req.path.start_with?('/rails/active_storage/') }
end
