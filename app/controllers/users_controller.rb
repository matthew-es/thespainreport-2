class UsersController < ApplicationController
	before_action :set_user, only: [:show, :edit, :update, :destroy]
	
	def login
	end
	
	def signup
		@user = User.new
	end
  
	def newsession
		user = User.find_by_email(params[:email])
		# If the user exists AND the password entered is correct.
		if user && user.authenticate(params[:password])
			# Save the user id inside the browser cookie. This is how we keep the user logged in
			session[:user_id] = user.id
			redirect_to '/'
			flash[:success] = "Welcome back!"
		else
		# If user's login doesn't work, send them back to the login form.
			redirect_to :back
			flash[:password] = "<a href=\"#{new_password_reset_path}\" style=\"color: #AA151B !important; text-decoration:underline !important;\">Forgotten your password?</a>"
		end
	end

	def destroysession
		session[:user_id] = nil
		reset_session
		redirect_to '/'
		flash[:success] = "Thanks for reading!"
	end
	
	def first_email
	end
	
	def password_reset
	end
	
	def updated
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
	
	def reset_tokens
		if current_user.nil? 
			redirect_to root_url
		elsif !current_user.nil?
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
		elsif !current_user.nil?
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
		elsif !current_user.nil?
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
	
	# GET /users/new
	def new
		if current_user.nil? 
			redirect_to root_url
		elsif !current_user.nil?
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
				format.html { render :new }
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
			params.require(:user).permit(:email, :email_confirmed, :emails, :emaillanguage, :password, :password_confirmation, :password_digest, :password_reset_token, :password_reset_sent_at, :role, :sitelanguage, :confirm_token)
		end
end
