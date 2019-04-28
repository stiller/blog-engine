Rails.application.routes.draw do
  resources :users, only: [:create]
  post 'users/login', to: 'users#login'
  get 'users/me', to: 'users#show'
  resources :posts, only: [:create, :show] do
    resources :comments, only: [:create]
  end
  resources :comments do
    resources :comments, only: [:create]
  end
end
