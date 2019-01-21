Rails.application.routes.draw do
  root 'home#index'
  
  get 'home/index'
  get 'articles/admin'
  get 'users/signup'
  post 'signup' => 'users#create'
  get 'users/login'
  post '/login' => 'users#newsession'
  get '/users/logout' => 'users#destroysession'
  
  resources :users
  resources :uploads
  resources :campaigns
  resources :languages
  resources :statuses
  resources :types
  resources :articles
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
