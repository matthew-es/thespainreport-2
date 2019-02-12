Rails.application.routes.draw do
  
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
  get 'es' => 'home#es'
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
