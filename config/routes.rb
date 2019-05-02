Rails.application.routes.draw do
  
  resources :tweets
  resources :visits
  resources :plans
  if Rails.env.production?
    constraints(host: /^(?!www\.)/i) do
      get '(*any)' => redirect { |params, request|
        URI.parse(request.url).tap { |uri| uri.host = "www.#{uri.host}" }.to_s
      }
    end
  else
  end

  root 'home#index'
  
  get 'trial', to: redirect("http://www.thespainreport.es/articles/32-180101210225-catalan-separatism")
  get 'twitterpatreon' => 'home#patreon'
  get 'rss' => 'home#index', defaults: { format: 'rss' }
  get 'rss/es' => 'home#es', defaults: { format: 'rss' }
  get 'rss/eng' => 'home#eng', defaults: { format: 'rss' }
  get 'audio' => 'home#audio'
  get 'es/audio' => 'home#audio_es'
  get 'es' => 'home#es'
  get 'home/index'
  get 'articles/admin'
  get 'users/signup'
  post 'editor_creates_new_user' => 'users#editor_creates_new_user'
  post 'signup' => 'users#create'
  get 'users/login'
  post '/login' => 'users#newsession'
  get 'users/logout' => 'users#destroysession'
  get 'users/reset_tokens' => 'users#reset_tokens'
  get 'users/updated' => 'users#updated'
  
  resources :users do
    member do
      get :first_email
      get :password_reset
      get :update_email_amount
      get :update_email_language
    end
  end
  resources :uploads
  resources :campaigns
  resources :languages
  resources :statuses
  resources :types
  resources :articles
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
