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
			@can_read = @user.can_read
			@level = @user.level_amount
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
		frame = frame
		
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
		
		@frame = Frame.find(frame)
		@frame_id = @frame.id
		
		@subscribe = root_url + @stub_value + @frame.link_slug
		@increase = root_url + @stub_increase + @frame.link_slug
		@restart = root_url + @stub_restart + @frame.link_slug
	end
	
end