class ApplicationController < ActionController::Base
	
	def current_user
   	@current_user ||= User.find(session[:user_id]) if session[:user_id]
	rescue ActiveRecord::RecordNotFound
   	session[:user_id] = nil # or reset_session
	end
	helper_method :current_user
	
	
	def set_status(user)
		if user.nil?
		
		else
			@user = user
			@status = @user.status
			@can_read_date = @user.can_read_date
			@level = @user.level_amount
			@account = @user.account
			@account_status = @account.account_status unless @user.account.nil?
			@role = @user.account_role
			
			if @status == 3 && @can_read_date > Time.now
				@cta = @frame.button_cta
			elsif @status == 3 && @can_read_date < Time.now
				@cta = @frame.button_cta_trial_over
			elsif @status == 2 && @level == 0
				@cta = @frame.button_cta_increase
			elsif @status == 2 && @level.between?(1, 4)
				@cta = @frame.button_cta_increase
			elsif @status == 2 && @level.between?(5, 9)
				@cta = @frame.button_cta_increase
			elsif @status == 2 && @level.between?(10, 24)
				@cta = @frame.button_cta_increase
			elsif @status == 2 && (@level >= 25)
				@cta = @frame.button_cta_increase
			elsif @status == 1
				@cta = @frame.button_cta_increase
			else end
			
			@admin = @status == 1
			@super_patron = @status == 2 && (@level > 2500)
			@patron_25 = @status == 2 && (@level == 2500)
			@patron_10 = @status == 2 && @level.between?(1000, 2499)
			@patron_5 = @status == 2 && @level.between?(500, 999)
			@patron_1 = @status == 2 && @level.between?(100, 499)
			@patron_paused = (@user.account.subscriptions.last.is_active == false) unless @user.account.subscriptions.blank?
			
			@patron = @patron_1 || @patron_5 || @patron_10 || @patron_25 || @patron_paused
			@reader_trial = (@status == 3 && @can_read_date > Time.now)
			@reader_trial_over = @status == 3 && @can_read_date < Time.now
			@reader = @readertrial || @reader_trial_over
			@get_prints = @admin || @super_patron || @patron_25 || @reader_trial
			
			@account_owner = @role == 1
			@member = @role == 2
			
			if @account.total_support.nil?
				@accountpaying = false
			elsif @account.total_support > 0
				@accountpaying = true
			else
				@accountpaying = false
			end
			
			@can_read_level_1 = @admin || @reader_trial|| @super_patron || @patron_25 || @patron_10 || @patron_5  || @patron_1
			@can_read_level_5 = @admin || @reader_trial|| @super_patron || @patron_25 || @patron_10 || @patron_5
			@can_read_level_10 = @admin || @reader_trial|| @super_patron || @patron_25 || @patron_10
			@can_read_level_25 = @admin || @reader_trial|| @super_patron || @patron_25
			@cannot_read_1 = @reader_trial_over || @patron_paused || @patron_1
			@cannot_read_2 = @reader_trial_over || @patron_paused || @patron_1 || @patron_5
			
			@reactivate = reactivate_subscription_payment_url(@user.account.subscriptions.last.reactivate_token) unless @user.account.subscriptions.blank? || @user.account.subscriptions.last.reactivate_token.nil?
		end
	end
	
	
	def set_country
		require 'uri'
		require 'net/http'
		
		ip = request.remote_ip
		url = URI("https://api.ipdata.co/#{ip}?api-key=22f4bd1298c4266e3de9e41b9f930eb92a2e7d4264b2f7250db75a93&fields=country_code,ip,threat")
		http = Net::HTTP.new(url.host, url.port)
		http.use_ssl = true
		request = Net::HTTP::Get.new(url)
		
		response = http.request(request)
		data = JSON.parse(response.read_body)
		
		@ip_lookup_country = data["country_code"]
		@ip_address = data["ip"]
		
		@country = Country.find_by_country_code(@ip_country)
		if @country.nil?
			@country_code = "ROW"
		else
			@country_code = @country.country_code
		end
		
		threats = [
		threat_proxy = data["threat"]["is_proxy"],
		threat_attacker = data["threat"]["is_known_attacker"],
		threat_abuser = data["threat"]["is_known_abuser"],
		threat_threat = data["threat"]["is_threat"],
		threat_bogon = data["threat"]["is_bogon"]
		]
		
		if threats.any?
			render file: "#{Rails.root}/public/404", layout: true, status: 404
		end
	end
	
	
	def set_language_frame(language, frame)
		language = language
		
		if language == 1
			@language = 1
			@stub_value = "value/"
			@stub_increase = "value/"
			@stub_restart = "value/" 
			@plans = Plan.english.all.order("price DESC")
			@countries = Country.all.where.not(country_code: "ROW").order("name_en ASC")
			@row = Country.where(country_code: "ROW")
		elsif language == 2
			@language = 2
			@stub_value = "valor/"
			@stub_increase = "valor/"
			@stub_restart = "valor/" 
			@plans = Plan.spanish.all.order("price DESC")
			@countries = Country.all.where.not(country_code: "ROW").order("name_es ASC")
			@row = Country.where(country_code: "ROW")
		else end
		
		frame = frame
		if frame.nil?
			if language == 1 
				@frame = Frame.find_by(link_slug: "guarantee")
				@frame_id = @frame.id
			elsif language == 2
				@frame = Frame.find_by(link_slug: "garantizar")
				@frame_id = @frame.id
			else end
		else
			@frame = Frame.find(frame)
			@frame_id = @frame.id
		end
		
		puts "USER IS: " + @user.to_s
		
		@subscribe = root_url + @stub_value + @frame.link_slug
		@increase = root_url + @stub_increase + @frame.link_slug
		@restart = root_url + @stub_restart + @frame.link_slug
	end
	
	def placeholders
		case @language
			when 1
				@place_email = "Enter your email address..."
				@place_invoice_name = "Enter your invoice name..."
				@place_invoice_tax_id = "Enter your tax ID..."
				@place_invoice_address = "Enter your invoice address..."
			when 2
				@place_email = "Introduzca su correo electrónico…"
		end
	end
	
	
	def has_existing_payment_method
		unless current_user.nil? || !current_user.account.present? || !current_user.account.stripe_payment_method.present?
			@existing_pm = Stripe::PaymentMethod.retrieve(current_user.account.stripe_payment_method)
			@existing_pm_brand = @existing_pm.card.brand
			@existing_pm_last4 = @existing_pm.card.last4
			@existing_pm_month = @existing_pm.card.exp_month
			@existing_pm_year = @existing_pm.card.exp_year
		end
	end
	
	
end