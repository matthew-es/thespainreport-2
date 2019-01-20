Rails.application.routes.draw do
  resources :users
  resources :uploads
  root 'home#index'
  
  get 'home/index'
  get 'articles/admin'
  
  resources :campaigns
  resources :languages
  resources :statuses
  resources :types
  resources :articles
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
