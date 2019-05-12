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
  get 'articles/touser' => 'articles#touser'
  
  get 'users/signup'
  get 'signup' => 'users#signup'
  post 'signup' => 'users#create'
  get 'password' => 'users#password'
  get 'clave' => 'users#clave'
  post 'password_link' => 'users#password_link'
  post 'change_password' => 'users#change_password'
  post 'cambiar_clave' => 'users#cambiar_clave'
  get 'users/login'
  get 'login' => 'users#login'
  post 'login' => 'users#newsession'
  get 'users/logout' => 'users#destroysession'
  get 'logout' => 'users#destroysession'
  get 'users/reset_tokens' => 'users#reset_tokens'
  get 'users/updated' => 'users#updated'
  post 'editor_creates_new_user' => 'users#editor_creates_new_user'
  resources :users do
    member do
      get :first_email
      get :new_password
      get :clave_nueva
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
