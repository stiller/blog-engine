Rails.application.routes.draw do
  resources :users, only: [:create]
  post 'users/login', to: 'users#login'
  get 'users/me', to: 'users#show'
end
