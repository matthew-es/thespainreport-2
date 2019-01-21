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
			# Save the user id inside the browser cookie. This is how we keep the user 
			# logged in when they navigate around our website.
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
	
	def index
		if current_user.nil? 
			redirect_to root_url
		elsif !current_user.nil?
			@users = User.all
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
		elsif !current_user.role?
			
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
				format.html { redirect_to @user, notice: 'User was successfully updated.' }
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
			params.require(:user).permit(:email, :email_confirmed, :password, :password_confirmation, :password_digest, :role, :confirm_token)
		end
end
