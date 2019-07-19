class UsersController < ApplicationController
	before_action :set_user, only: [:show, :edit, :update, :destroy]
	
	def login
	end
	
	def signup
		@user = User.new
	end
	
	def apuntese
		@user = User.new
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
		session[:user_id] = nil
		reset_session
		redirect_back(fallback_location: root_path)
		flash[:success] = "Thanks for reading!"
	end
	
	def confirm_email
		@user = User.find_by_confirm_token(params[:id])
		@user.update(
			email_confirmed: true
			)
		
		if @user.emaillanguage == 1
			UserMailer.password_link(@user).deliver_now
			flash[:success] = "Well done, email confirmed! Now you can set a password. Check your inbox…"
			redirect_to '/users/updated'
		elsif @user.emaillanguage == 2
			UserMailer.password_link_es(@user).deliver_now
			flash[:success] = "¡Enhorabuena, ha confirmado su correo! Ahora puede elegir una clave. Mire su correo…"
			redirect_to '/users/updated'
		else
		end
	end
	
	def password
	end
	
	def clave
	end
	
	def password_link
		user = User.find_by_email(params[:email])
		if user
			user.password_reset_sent_at = Time.zone.now
			user.save!(:validate => false)
			
			if URI(request.referer).path == '/password'
	   		UserMailer.password_link(user).deliver_now
	   		flash[:success] = "Well done! Check your email for the link to create a new password"
	   	elsif URI(request.referer).path == '/clave'
	   		UserMailer.password_link_es(user).deliver_now
	   		flash[:success] = "Correcto. Compruebe su correo para el enlace para crear una clave nueva"
	   	else
	   	end
			redirect_to '/users/updated'
		else
	   	if URI(request.referer).path == '/password'
	   		flash[:tryagain] = "See if you have typed that correctly and try again…"
	   	elsif URI(request.referer).path == '/clave'
	   		flash[:tryagain] = "Mire si lo ha escrito bien e inténtelo de nuevo…"
	   	else
	   	end
	   	redirect_back(fallback_location: root_path)
		end
	end
	
	def new_password
		@user = User.find_by_confirm_token(params[:id])
		if @user.password_reset_sent_at < 30.minutes.ago
			flash[:success] = "More than 30 minutes have passed since you asked to change your password. To protect your account, we limit this function.<br /><br /><a href=\"/password\">Request a new link to change your password</a>"
			redirect_to '/users/updated'
		else
		end
	end
	
	def clave_nueva
		@user = User.find_by_confirm_token(params[:id])
		if @user.password_reset_sent_at < 30.minutes.ago
			flash[:success] = "Han pasado más de 30 minutos desde que pidió en enlace para cambiar su clave. Para proteger su cuenta, limitamos esta función.<br /><br /><a href=\"/clave\">Pide un enlace nuevo para cambiar su clave</a>"
			redirect_to '/users/updated'
		else
		end
	end
	
	def cambiar_clave
		@user = User.find_by_confirm_token(params[:confirm_token])
		@user.update(
			password: params[:password],
			password_confirmation: params[:password_confirmation]
			)
		
		if params[:password].blank? || !@user.save
			flash[:tryagain] = "Inténtelo de nuevo…"
			redirect_back(fallback_location: root_path)
		elsif @user.save
			flash[:success] = "Ha actualizado su clave con éxito."
			redirect_to '/users/updated'
		else
			flash[:tryagain] = "Inténtelo de nuevo…"
			redirect_back(fallback_location: root_path)
		end
	end
	
	def change_password
		@user = User.find_by_confirm_token(params[:confirm_token])
		@user.update(
			password: params[:password],
			password_confirmation: params[:password_confirmation]
			)
		
		if params[:password].blank? || !@user.save
			flash[:tryagain] = "Try again…"
			redirect_back(fallback_location: root_path)
		elsif @user.save
			flash[:success] = "You have successfully updated your password."
			redirect_to '/users/updated'
		else
			flash[:tryagain] = "Try again…"
			redirect_back(fallback_location: root_path)
		end
	end
	
	def update_email_amount
		u = User.find_by_confirm_token(params[:id])
		if u
   		u.update(emails: params[:emails])
   		if [1, 3].include?u.emaillanguage
	   		flash[:success] = "Well done! You have successfully updated the amount of email you want."
	   	elsif u.emaillanguage == 2
	   		flash[:success] = "¡Olé! Ha actualizado correctamente la cantidad de correos que quiere."
	   	end
   		redirect_to '/users/updated'
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
	   	redirect_to '/users/updated'
	   else
	   	redirect_to root_url
	   end
	end
	
	def updated
	end
	
	def reset_tokens
		if current_user.nil? 
			redirect_to root_url
		elsif current_user.role == 1
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
		elsif current_user.role == 1
			@users = User.all.order("email ASC")
		else
			redirect_to root_url
		end
	end

	# GET /users/1
	# GET /users/1.json
	def show
		if current_user.nil? 
			redirect_to root_url
		elsif current_user.role == 1
			@user = User.find(params[:id])
		else
			redirect_to root_url
		end
	end
	
	def editor_creates_new_user
		autopassword = 'L e @ 4' + SecureRandom.hex(32)
		generate_token = SecureRandom.urlsafe_base64.to_s
		
		array2 = params[:email].split(/\n/)
		array2.each do |e|
		user = User.create!(
			email: e,
			confirm_token: generate_token,
			password: autopassword,
			password_confirmation: autopassword,
			password_reset_token: generate_token,
			password_reset_sent_at: Time.zone.now,
			role: params[:role],
			sitelanguage: params[:sitelanguage],
			emails: params[:emails],
			emaillanguage: params[:emaillanguage],
			email_confirmed: 1
			)
		end 
		
		redirect_to users_path
	end
	
	def new_reader
		autopassword = 'L e @ 4' + SecureRandom.hex(32)
		generate_token = SecureRandom.urlsafe_base64.to_s
		
		begin
			user = User.create!(
			email: params[:email],
			confirm_token: generate_token,
			password: autopassword,
			password_confirmation: autopassword,
			password_reset_sent_at: Time.zone.now,
			role: 3,
			sitelanguage: params[:set_language],
			emails: 1,
			emaillanguage: params[:set_language],
			email_confirmed: false
			)
		
			if user.emaillanguage == 1
	   		UserMailer.welcome_link(user).deliver_now
	   		flash[:warning] = "Well done! Please check your inbox now and click on the link to confirm your email address"
	   	elsif user.emaillanguage == 2
	   		UserMailer.welcome_link_es(user).deliver_now
	   		flash[:warning] = "¡Enhorabuena!. Compruebe su correo ahora y haga clic en el enlace para confirmar la dirección"
	   	else
			end
			
			UserMailer.admin_new_reader(user).deliver_now
			redirect_to '/users/updated'
		rescue Exception => e
			if @article.nil?
				flash[:tryagain] = "Try again…"
				redirect_to '/signup'
			elsif @article.language_id == 1
				flash[:tryagain] = "Try again…"
				redirect_to '/signup'
			elsif @article.language_id == 2
				flash[:tryagain] = "Inténtelo de nuevo…"
				redirect_to '/signup'
			else
			end
		else
		ensure
		end
		
	end
	
	# GET /users/new
	def new
		if current_user.nil? 
			redirect_to root_url
		elsif current_user.role == 1
			@user = User.new
		else
			redirect_to root_url
		end
	end

	# GET /users/1/edit
	def edit
		if current_user.nil?
			redirect_to root_url
		elsif current_user.role == 1
			@user = User.find_by_id(params[:id])
		elsif User.find_by_id(params[:id]) != current_user
			redirect_to edit_user_path(current_user)
		elsif User.find_by_id(params[:id]) == current_user
			@user = current_user
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
			params.require(:user).permit(:account_id, :account_role, :email, :email_confirmed, :emails, :emaillanguage, :password, :password_confirmation, :password_digest, :password_reset_token, :password_reset_sent_at, :role, :sitelanguage, :confirm_token)
		end
end
