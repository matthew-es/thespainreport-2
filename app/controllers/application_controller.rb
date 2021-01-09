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
			@account_status = @user.account.account_status unless @user.account.nil?
			
			if @status == 3 && @can_read_date > Time.now
				@cta = @frame.button_cta
				@can_read_trial = true
			elsif @status == 3 && @can_read_date < Time.now
				@cta = @frame.button_cta_trial_over
				@can_read_trial_over = true
			elsif @status == 2 && @level == 0
				@cta = @frame.button_cta_increase
				@can_read_0 = true
			elsif @status == 2 && @level.between?(1, 4)
				@cta = @frame.button_cta_increase
				@can_read_1 = true
			elsif @status == 2 && @level.between?(5, 9)
				@cta = @frame.button_cta_increase
				@can_read_5 = true
			elsif @status == 2 && @level.between?(10, 24)
				@cta = @frame.button_cta_increase
				@can_read_10 = true
			elsif @status == 2 && @level >= 25
				@cta = @frame.button_cta_increase
				@can_read_25 = true
			elsif @status == 1
				@cta = @frame.button_cta_increase
				@can_read_admin = true
			else end
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
		
		@ip_country = data["country_code"]
		@ip_address = data["ip"]
		
		puts @ip_country
		
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
		
		puts data
		puts threats
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
		end
		
		
		@subscribe = root_url + @stub_value + @frame.link_slug
		@increase = root_url + @stub_increase + @frame.link_slug
		@restart = root_url + @stub_restart + @frame.link_slug
	end
	
end