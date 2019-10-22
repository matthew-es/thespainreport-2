Rails.application.routes.draw do
  
  resources :subscriptions
  resources :invoices
  resources :countries
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
  
  get 'ajax_test' => 'payments#ajax_test'
  
  resources :payments
  get 'guarantee', to: redirect("/")
  get 'garantizar', to: redirect("/")
  get 'support', to: redirect("/")
  get 'apoyar', to: redirect("/")
  get 'contribute', to: redirect("/")
  get 'contribuir', to: redirect("/")
  get 'pay', to: redirect("/")
  get 'pagar', to: redirect("/")
  
  # get 'guarantee' => "payments#pay"
  # get 'garantizar' => "payments#pagar"
  # get 'support' => "payments#pay"
  # get 'apoyar' => "payments#pagar"
  # get 'contribute' => "payments#pay"
  # get 'contribuir' => "payments#pagar"
  # get 'pay' => "payments#pay"
  # get 'pagar' => "payments#pagar"
  
  get 'trial', to: redirect("http://www.thespainreport.es/articles/32-180101210225-catalan-separatism")
  get 'twitterpatreon' => 'home#patreon'
  post 'stripe_credit_card' => 'payments#stripe_credit_card'
  post 'stripe_first_payment' => 'payments#stripe_first_payment'
  get 'confirm', to: redirect("/")
  post 'stripe_webhook' => 'payments#stripe_webhook'
  
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
  get 'apuntese' => 'users#apuntese'
  post 'signup' => 'users#create'
  post 'new_reader' => 'users#new_reader'
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
  post 'editor_modifies_accounts' => 'accounts#editor_modifies_accounts'
  resources :users do
    member do
      get :confirm_email
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
  resources :accounts
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
