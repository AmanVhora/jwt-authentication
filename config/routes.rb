Rails.application.routes.draw do
  resources :posts
  resources :users
  post 'auth/login', to: 'authentication#login'
end
