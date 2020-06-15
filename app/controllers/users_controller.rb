class UsersController < ApplicationController
	before_action :set_user, only: [:show, :edit, :update, :destroy]
	
	# 1. Set up
	# 2. Reader sign up, confirm email, first password
	# 3. Log in, password reminders
	# 4. Update user options via links
	
	# 1. Set up
	#---------------------------------------------------------------------------
	def default_frame_eng
		set_language_frame(1, Frame.find_by(link_slug: "guarantee").id)
	end
	
	def default_frame_es
		set_language_frame(2, Frame.find_by(link_slug: "garantizar").id)
	end
	
	
	# 2. Reader sign up
	#---------------------------------------------------------------------------
	def signup
		@article_id = "0"
		default_frame_eng
	end
	
	def apuntese
		@article_id = "0"
		default_frame_es
	end
	
	def thanks
		default_frame_eng
	end
	
	def gracias
		default_frame_es
	end
	
	def new_reader
		autopassword = 'L e @ 4' + SecureRandom.hex(32)
		generate_token = SecureRandom.urlsafe_base64.to_s
		
		@user = User.find_by(email: params[:email])
		@article_id = params[:article_id]
		@frame = Frame.find_by(id: params[:frame_id])
		@frame_id = @frame.id
		@frame_quest = @frame.emotional_quest_action
		@frame_value_now_message = @frame.emotional_quest_role
		@frame_stub = @frame.link_slug
		
		case @article_id
			when "0"
				case URI(request.referer).path
					when "/" then sign_up_article = "/"
					when "/es" then sign_up_article = "/es"
					when "/signup" then sign_up_article = "/signup"
					when "/apuntese" then sign_up_article = "/apuntese"
				end
			else
				a = Article.find(@article_id)
				sign_up_article = a.headline
		end
		
		if @user.nil?
			begin
				user = User.create!(
				email: params[:email],
				confirm_token: generate_token,
				password: autopassword,
				password_confirmation: autopassword,
				password_reset_sent_at: Time.zone.now,
				status: 3,
				level_amount: 0,
				frame_id: @frame_id,
				sitelanguage: params[:set_language],
				emails: 1,
				emaillanguage: params[:set_language],
				email_confirmed: false
				)
				
				Bookmark.create!(
					user_id: user.id,
					new_email_reader_article: true,
					article_id: @article_id,
					article_headline: sign_up_article,
					frame_id: @frame_id,
					frame_emotional_quest_action: @frame_quest
					)
				
				admin_subject = "✅ New reader: #{user.email}"
				admin_message = (
					"Email: #{user.email}" + "<br />" + "Language: #{user.sitelanguage}" + "<br />" + "Article: #{sign_up_article}" + "<br />" + "Frame: #{@frame_quest}"
					).html_safe
				UserMailer.admin_alert(admin_subject, admin_message).deliver_now
				session[:user_id] = user.id
				case user.sitelanguage
					when 1
						UserMailer.welcome_reader(user).deliver_now
						@url_stub = "/value/"
					when 2
				   		UserMailer.welcome_reader_es(user).deliver_now
				   		@url_stub = "/valor/"
				end
				flash[:success] = @frame_value_now_message
				# redirect_to @url_stub + @frame_stub
				redirect_to edit_user_path(user)
			rescue Exception => e
			end
		else
			case params[:set_language]
				when "1" then @message = "Try again…"
				when "2" then @message = "Inténtelo de nuevo…"
			end
			flash[:tryagain] = @message
			redirect_back(fallback_location: root_path)
		end
	end
	
	def confirm_email
		default_frame_eng
		
		@user = User.find_by_confirm_token(params[:id])
		@user.update(
			email_confirmed: true
			)
	end
	
	def confirmar_correo
		default_frame_es
		
		@user = User.find_by_confirm_token(params[:id])
		@user.update(
			email_confirmed: true
			)
	end
	
	
	# 3. Log in, password reminders
	#---------------------------------------------------------------------------
	def login
		default_frame_eng
	end
	
	def entrar
		default_frame_es
	end
	
	def newsession
		user = User.find_by_email(params[:email])
		# If the user exists AND the password entered is correct.
		if user && user.authenticate(params[:password])
			# Save the user id inside the browser cookie. This is how we keep the user logged in
			session[:user_id] = user.id
			redirect_back(fallback_location: root_path)
			flash[:success] = "Welcome back!"
		else
		# If user's login doesn't work, send them back to the login form.
			redirect_back(fallback_location: root_path)
			flash[:tryagain] = "Try again…"
		end
	end

	def destroysession
		session.delete(:user_id)
		reset_session
		redirect_back(fallback_location: root_path)
		flash[:success] = "Thanks for reading!"
	end

	def password
		default_frame_eng
	end
	
	def clave
		default_frame_es
	end
	
	def get_new_password_link
		user = User.find_by_email(params[:email])
		if user
			user.password_reset_sent_at = Time.zone.now
			user.save!(:validate => false)
			case URI(request.referer).path
				when '/password'
					subject = "🔑 Get a new password: click on this link"
					UserMailer.password_link(user, subject).deliver_now
					@message = "Well done. Check your email for the link to create a new password"
				when '/clave'
					subject = "🔑 Obtenga una nueva contraseña: haga clic en este enlace"
					UserMailer.password_link(user, subject).deliver_now
					@message = "Correcto. Ya tiene un correo electrónico con el enlace para crear una contraseña nueva"
		   	end
		   	flash[:success] = @message
			redirect_back(fallback_location: root_path)
		else
		   	case URI(request.referer).path
		   		when '/password' then @message = "See if you have typed that correctly and try again…"
	   			when '/clave' then @message = "Mire Ud. si ha escrito bien eso e inténtelo de nuevo…"
		   	end
		   	flash[:tryagain] = @message
	   		redirect_back(fallback_location: root_path)
		end
	end
	
	def enter_new_password
		confirm_email
		@user = User.find_by_confirm_token(params[:id])
		
		if !@user
			redirect_to "/"
		else
		end
		
		default_frame_eng
	end
	
	def introducir_clave_nueva
		confirmar_correo
		@user = User.find_by_confirm_token(params[:id])
		
		if !@user
			redirect_to "/"
		else
		end
		
		default_frame_es
	end
	
	def change_password
		@user = User.find_by_confirm_token(params[:confirm_token])
		@user_language = @user.sitelanguage
		@user.update(
			password: params[:password],
			password_confirmation: params[:password_confirmation]
			)
		
		if params[:password].blank? || !@user.save
			case @user_language
				when 1 then @message = "Try again…"
				when 2 then @message = "Inténtelo de nuevo"
			end
			flash[:tryagain] = @message + @user.errors.full_messages.to_s
			redirect_back(fallback_location: root_path)
		elsif @user.save
			case @user_language
				when 1
					@message = "Well done. You have updated your password."
					@location = "/login"
					@subject = "⚠️ Your password was just changed: is that what you wanted to happen?"
				when 2
					@message = "Enhorabuena. Ha actualizado su contraseña."
					@location = "/entrar"
					@subject = "⚠️ Se acaba de cambiar su contraseña: ¿es lo que quería hacer?"
			end
			@user.update(
				confirm_token: SecureRandom.urlsafe_base64.to_s
				)
			UserMailer.password_changed(@user, @subject).deliver_now
			flash[:success] = @message
			redirect_to @location
		else
			case @user_language
				when 1 then @message = "Try again…"
				when 2 then @message = "Inténtelo de nuevo"
			end
			flash[:tryagain] = @message
			redirect_back(fallback_location: root_path)
		end
	end
	
	
	# 4. Update user options via links
	#---------------------------------------------------------------------------
	def update_email_amount
		u = User.find_by_confirm_token(params[:id])
		if u
   			u.update(emails: params[:emails])
	   		if [1, 3].include?u.emaillanguage
		   		flash[:success] = "Well done! You have successfully updated the amount of email you want."
		   	elsif u.emaillanguage == 2
		   		flash[:success] = "¡Olé! Ha actualizado correctamente la cantidad de correos que quiere."
		   	end
   		redirect_to '/users/thanks'
		else
   		redirect_to root_url
		end
	end
	
	def update_email_language
		u = User.find_by_confirm_token(params[:id])
		if u
			u.update(emaillanguage: params[:emaillanguage])
				if [1, 3].include?u.emaillanguage
				   flash[:success] = "Well done! You have successfully updated the language you want the emails in."
				elsif u.emaillanguage == 2
				   flash[:success] = "¡Olé! Ha actualizado correctamente el idioma en el que desea recibir los correos."
				end
			redirect_to '/users/thanks'
		else
			redirect_to root_url
		end
	end
	
	def reset_tokens
		if current_user.nil? 
			redirect_to root_url
		elsif current_user.status == 1
			User.all.each do |u|
				u.update(confirm_token: SecureRandom.urlsafe_base64.to_s)
			end
			redirect_to users_path and return
		else
			redirect_to root_url
		end
	end
	
	def index
		if current_user.nil? 
			redirect_to root_url
		elsif current_user.status == 1
			@latest_readers = User.readers.limit(20).order("updated_at DESC")
			@latest_super_patrons  = User.super_patrons.limit(20).order("updated_at DESC")
			@latest_patrons  = User.patrons.limit(20).order("updated_at DESC")
			@latest_authors = User.authors.order("updated_at DESC")
			@patrons_nil_account = User.where(status: 2).where(account_id: nil).order("created_at DESC")
			
			if params[:search]
				search_string = params[:search]
				@search_results = User.all.where("email LIKE ?", "%#{search_string}%").order("created_at DESC")
			end

			
#			User.all.each do |u|
#				if [1, 2].include?u.status
#					u.update(
#						level_amount: 1
#						)
#				elsif u.status == 3
#					u.update(
#						level_amount: 0
#						)
#				else
#				end
#			end
		else
			redirect_to root_url
		end
	end

	# GET /users/1
	# GET /users/1.json
	def show
		if current_user.nil? 
			redirect_to root_url
		elsif current_user.status == 1
			@user = User.find(params[:id])
		else
			redirect_to root_url
		end
	end
	
	def editor_creates_new_user
		autopassword = 'L e @ 4' + SecureRandom.hex(32)
		generate_token = SecureRandom.urlsafe_base64.to_s
		
		array2 = params[:email].split(/\r\n/)
		
		array2.each do |e|
			user = User.find_by_email(e)
			
			if user.present?
			
			else
				User.create!(email: e,
					confirm_token: generate_token,
					password: autopassword,
					password_confirmation: autopassword,
					password_reset_token: generate_token,
					password_reset_sent_at: Time.zone.now,
					status: params[:role],
					sitelanguage: params[:sitelanguage],
					emails: params[:emails],
					emaillanguage: params[:emaillanguage],
					email_confirmed: 1
					)
			end
		end
		
		redirect_to users_path
	end
	
	# GET /users/new
	def new
		if current_user.nil? 
			redirect_to root_url
		elsif current_user.status == 1
			@user = User.new
		else
			redirect_to root_url
		end
	end

	# GET /users/1/edit
	def edit
		if current_user.nil?
			redirect_to root_url
		elsif current_user.status == 1
			@user = User.find_by_id(params[:id])
			@status = @user.status
			set_language_frame(current_user.sitelanguage, current_user.frame_id)
		elsif User.find_by_id(params[:id]) != current_user
			redirect_to edit_user_path(current_user)
			set_language_frame(current_user.sitelanguage, current_user.frame_id)
		elsif User.find_by_id(params[:id]) == current_user
			set_status(current_user)
			set_language_frame(current_user.sitelanguage, current_user.frame_id)
		else
			redirect_to root_url
		end
	end

	# POST /users
	# POST /users.json
	def create
		@user = User.new(user_params)
		
		respond_to do |format|
			if @user.save
				format.html { redirect_to @user, notice: 'User was successfully created.' }
				format.json { render :show, status: :created, location: @user }
			else
				format.html { render :tryagain }
				format.json { render json: @user.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT /users/1
	# PATCH/PUT /users/1.json
	def update
		respond_to do |format|
			if @user.update(user_params)
		   	format.html { redirect_to edit_user_path(@user), notice: 'Reader was successfully updated.' }
				format.json { render :show, status: :ok, location: @user }
			else
				format.html { render :edit }
				format.json { render json: @user.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /users/1
	# DELETE /users/1.json
	def destroy
		@user.destroy
		respond_to do |format|
			format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
			format.json { head :no_content }
		end
	end

	private
		# Use callbacks to share common setup or constraints between actions.
		def set_user
			@user = User.find(params[:id])
		end

		# Never trust parameters from the scary internet, only allow the white list through.
		def user_params
			params.require(:user).permit(:account_id, :frame_id, :account_role, :country, :email, :email_confirmed, :emails, :emaillanguage, :level_amount, :mailing_address, :password, :password_confirmation, :password_digest, :password_reset_token, :password_reset_sent_at, :status, :sitelanguage, :confirm_token, :can_read)
		end
end