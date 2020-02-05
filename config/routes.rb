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
	
	get 'signup' => 'users#signup'
	get 'apuntese' => 'users#apuntese'
	post 'new_reader' => 'users#new_reader'
	
	get 'users/login' => 'users#login'
	get 'login' => 'users#login'
	get 'users/entrar' => 'users#entrar'
	get 'entrar' => 'users#entrar'
	post 'login' => 'users#newsession'
	get 'users/logout' => 'users#destroysession'
	get 'logout' => 'users#destroysession'
	
	get 'password' => 'users#password'
	get 'clave' => 'users#clave'
	post 'get_new_password_link' => 'users#get_new_password_link'
	post 'change_password' => 'users#change_password'
	
	resources :payments
	
	get 'pay', to: redirect('value/pay')
	get 'pay/:slug', to: redirect { |path, req| "value/#{path[:slug]}" }
	get 'contribute', to: redirect('value/contribute')
	get 'contribute/:slug', to: redirect { |path, req| "value/#{path[:slug]}" }
	get 'guarantee', to: redirect('value/guarantee')
	get 'guarantee/:slug', to: redirect { |path, req| "value/#{path[:slug]}" }
	get 'support', to: redirect('value/support')
	get 'support/:slug', to: redirect { |path, req| "value/#{path[:slug]}" }
	get 'subscribe', to: redirect('value/subscribe')
	get 'subscribe/:slug', to: redirect { |path, req| "value/#{path[:slug]}" }
	get 'value/:slug' => 'payments#pay'
	get 'value/' => 'payments#pay'
	
	get 'pagar', to: redirect('valor/pagar')
	get 'pagar/:slug', to: redirect { |path, req| "valor/#{path[:slug]}" }
	get 'contribuir', to: redirect('valor/contribuir')
	get 'contribuir/:slug', to: redirect { |path, req| "valor/#{path[:slug]}" }
	get 'garantizar', to: redirect('valor/garantizar')
	get 'garantizar/:slug', to: redirect { |path, req| "valor/#{path[:slug]}" }
	get 'apoyar', to: redirect('valor/apoyar')
	get 'apoyar/:slug', to: redirect { |path, req| "valor/#{path[:slug]}" }
	get 'suscribirse', to: redirect('valor/suscribirse')
	get 'suscribirse/:slug', to: redirect { |path, req| "valor/#{path[:slug]}" }
	get 'valor/:slug' => 'payments#pagar'
	get 'valor/' => 'payments#pagar'
	
	get 'stripe_get_payment_intent' => 'payments#stripe_get_payment_intent'
	get 'confirm_credit_card' => 'payments#stripe_confirm_payment'
	get 'confirmar_tarjeta' => 'payments#stripe_confirm_payment'
	post '/webhook_events/:source', to: 'webhook_events#create'
	post 'check_if_user' => 'payments#check_if_user'
	post 'new_payment_error' => 'payment_errors#create_payment_error'
	post 'stripe_credit_card' => 'payments#stripe_credit_card'
	post 'stripe_first_payment' => 'payments#stripe_first_payment'
	
	get 'users/reset_tokens' => 'users#reset_tokens'
	get 'users/updated' => 'users#updated'
	get 'thanks' => 'users#thanks'
	get 'gracias' => 'users#gracias'
	
	get 'trial', to: redirect("http://www.thespainreport.es/articles/32-180101210225-catalan-separatism")
	get 'twitterpatreon' => 'home#patreon'
	
	get 'home/index'
	get 'rss' => 'home#index', defaults: { format: 'rss' }
	get 'podcast' => 'home#podcast'
	get 'rss/podcast' => 'home#podcast', defaults: { format: 'rss' }
	get 'rss/podcast/mp3' => 'home#podcast_mp3', defaults: { format: 'rss' }
	get 'bennettinspain', to: redirect("https://www.thespainreport.es/articles/397-200114142547-bennett-in-spain")
	get 'benetinspain', to: redirect("https://www.thespainreport.es/articles/397-200114142547-bennett-in-spain")
	get 'benettinspain', to: redirect("https://www.thespainreport.es/articles/397-200114142547-bennett-in-spain")
	get 'bennetinspain', to: redirect("https://www.thespainreport.es/articles/397-200114142547-bennett-in-spain")
	get 'bennett_in_spain', to: redirect("https://www.thespainreport.es/articles/397-200114142547-bennett-in-spain")
	get 'benet_in_spain', to: redirect("https://www.thespainreport.es/articles/397-200114142547-bennett-in-spain")
	get 'benett_in_spain', to: redirect("https://www.thespainreport.es/articles/397-200114142547-bennett-in-spain")
	get 'bennet_in_spain', to: redirect("https://www.thespainreport.es/articles/397-200114142547-bennett-in-spain")
	get 'bennett-in-spain', to: redirect("https://www.thespainreport.es/articles/397-200114142547-bennett-in-spain")
	get 'benet-in-spain', to: redirect("https://www.thespainreport.es/articles/397-200114142547-bennett-in-spain")
	get 'benett-in-spain', to: redirect("https://www.thespainreport.es/articles/397-200114142547-bennett-in-spain")
	get 'bennet-in-spain', to: redirect("https://www.thespainreport.es/articles/397-200114142547-bennett-in-spain")
	
	get 'es' => 'home#es'
	get 'es/rss' => 'home#es', defaults: { format: 'rss' }
	get 'es/podcast' => 'home#es_podcast'
	get 'es/rss/podcast' => 'home#es_podcast', defaults: { format: 'rss' }
	get 'es/rss/podcast/mp3' => 'home#es_podcast_mp3', defaults: { format: 'rss' }
	get 'bennettenespana', to: redirect("https://www.thespainreport.es/articles/398-200114142713-bennett-en-espana")
	get 'benetenespana', to: redirect("https://www.thespainreport.es/articles/398-200114142713-bennett-en-espana")
	get 'benettenespana', to: redirect("https://www.thespainreport.es/articles/398-200114142713-bennett-en-espana")
	get 'bennetenespana', to: redirect("https://www.thespainreport.es/articles/398-200114142713-bennett-en-espana")
	get 'bennett_en_espana', to: redirect("https://www.thespainreport.es/articles/398-200114142713-bennett-en-espana")
	get 'benet_en_espana', to: redirect("https://www.thespainreport.es/articles/398-200114142713-bennett-en-espana")
	get 'benett_en_espana', to: redirect("https://www.thespainreport.es/articles/398-200114142713-bennett-en-espana")
	get 'bennet_en_espana', to: redirect("https://www.thespainreport.es/articles/398-200114142713-bennett-en-espana")
	get 'bennett-en-espana', to: redirect("https://www.thespainreport.es/articles/398-200114142713-bennett-en-espana")
	get 'benet-en-espana', to: redirect("https://www.thespainreport.es/articles/398-200114142713-bennett-en-espana")
	get 'benett-en-espana', to: redirect("https://www.thespainreport.es/articles/398-200114142713-bennett-en-espana")
	get 'bennet-en-espana', to: redirect("https://www.thespainreport.es/articles/398-200114142713-bennett-en-espana")
	get 'bennettenespaña', to: redirect("https://www.thespainreport.es/articles/398-200114142713-bennett-en-espana")
	get 'benetenespaña', to: redirect("https://www.thespainreport.es/articles/398-200114142713-bennett-en-espana")
	get 'benettenespaña', to: redirect("https://www.thespainreport.es/articles/398-200114142713-bennett-en-espana")
	get 'bennetenespaña', to: redirect("https://www.thespainreport.es/articles/398-200114142713-bennett-en-espana")
	get 'bennett_en_españa', to: redirect("https://www.thespainreport.es/articles/398-200114142713-bennett-en-espana")
	get 'benet_en_españa', to: redirect("https://www.thespainreport.es/articles/398-200114142713-bennett-en-espana")
	get 'benett_en_españa', to: redirect("https://www.thespainreport.es/articles/398-200114142713-bennett-en-espana")
	get 'bennet_en_españa', to: redirect("https://www.thespainreport.es/articles/398-200114142713-bennett-en-espana")
	get 'bennett-en-españa', to: redirect("https://www.thespainreport.es/articles/398-200114142713-bennett-en-espana")
	get 'benet-en-españa', to: redirect("https://www.thespainreport.es/articles/398-200114142713-bennett-en-espana")
	get 'benett-en-españa', to: redirect("https://www.thespainreport.es/articles/398-200114142713-bennett-en-espana")
	get 'bennet-en-españa', to: redirect("https://www.thespainreport.es/articles/398-200114142713-bennett-en-espana")
	
	get 'articles/touser' => 'articles#touser'
	post 'editor_creates_new_user' => 'users#editor_creates_new_user'
	post 'editor_modifies_accounts' => 'accounts#editor_modifies_accounts'
	resources :users do
	member do
	  get :confirm_email
	  get :confirmar_correo
	  get :enter_new_password
	  get :introducir_clave_nueva
	  get :update_email_amount
	  get :update_email_language
	end
	end
	resources :uploads
	resources :frames
	resources :languages
	resources :statuses
	resources :types
	resources :articles
	resources :accounts
	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	end
