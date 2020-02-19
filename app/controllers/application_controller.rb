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
			@level = @user.level_amount
		end
	end
	
	def set_language_frame(language, frame)
		language = language
		frame = frame
		
		if language == 1
			@language = 1
			@stub_value = "value/"
			@stub_increase = "value/"
			@stub_restart = "value/" 
			@plans = Plan.english.all
		elsif language == 2
			@language = 2
			@stub_value = "valor/"
			@stub_increase = "valor/"
			@stub_restart = "valor/" 
			@plans = Plan.spanish.all
		else end
		
		@frame = Frame.find(frame)
		@frame_id = @frame.id
		
		@subscribe = root_url + @stub_value + @frame.link_slug
		@increase = root_url + @stub_increase + @frame.link_slug
		@restart = root_url + @stub_restart + @frame.link_slug
	end
	
end