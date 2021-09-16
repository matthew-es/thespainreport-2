class UsersController < ApplicationController
	before_action :set_user, only: [:show, :update, :destroy]
	
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
	
	def check_is_human
		check = SecureRandom.base64(10)
		session[:check] = check
		render json: {message: check}
	end
	
	def new_reader
		session_value = session[:check]
		form_value = params[:check_is_human]
		
		if session_value.blank? || form_value.blank?
			puts "This is bot spam, dude, not going to happen..."
		elsif session_value != form_value
			puts "More bot spam, session and form values are not the same..."
		elsif session_value == form_value
			user = User.find_by(email: params[:email_for_server])
			puts "Well, at least we can create a new user..."
			
			if user.nil?
				newuser = Patrons::CreateNewUser.process(params)
				puts newuser
				
				newaccount = Patrons::CreateNewAccount.process(newuser)
				puts newaccount
				
				frame = Frame.find(params[:frame_for_server])
				
				Patrons::UpdateLevelAmount.process(newuser, 2500)
				
				case newuser.sitelanguage
					when 1 then message = "Thanks for signing up..."
					when 2 then message = "Gracias por apuntarse..."
				end
				
				session[:user_id] = newuser.id
				flash[:success] = message
				redirect_to edit_user_path(newuser)
			else
				case params[:language_for_server]
					when "1" then message = "Try again…"
					when "2" then message = "Inténtelo de nuevo…"
				end
				
				flash[:tryagain] = message
				redirect_back(fallback_location: root_path)
			end
		else
		end
	end
	
	def confirm_email
		default_frame_eng
		@user = User.find_by_confirm_token(params[:id])
		@user.update(email_confirmed: true)
	end
	
	def confirmar_correo
		default_frame_es
		@user = User.find_by_confirm_token(params[:id])
		@user.update(email_confirmed: true)
	end
	
	def confirm_email_own_account
		default_frame_eng
		@user = User.find_by_confirm_token(params[:id])
		@user.update(email_confirmed: true)
		Patrons::CreateNewAccount.process(@user)
		
		puts "User confirmed and own account created..."
	end

	def confirm_change_email
		user = User.find_by(confirm_token: params[:id])
		
		if user.nil?
			flash[:tryagain] = "No"
		else
			email_entered = user.changing_email_to
			email_clicked = params[:new_email]

			if email_entered.nil?
				puts "Too late to change that one..."
				flash[:tryagain] = "No"
			elsif email_clicked == email_entered
				user.update(
					email: email_entered,
					changing_email_to: nil,
					confirm_token: SecureRandom.urlsafe_base64.to_s
					)
				
				redirect_to edit_user_path(current_user)
				case current_user.sitelanguage when 1
					message = "Well done, you have changed your email correctly..!"
				when 2
					message = "¡Olé, ha cambiado correctamente su correo electrónico..!"
				end
				flash[:success] = message
			else
				flash[:tryagain] = "No"
			end	
		end
	end
	
	def trial_over(user)
		u = User.find(user)
		
		u.update!(
			can_read_date: Time.zone.now,
			level_amount: 0
			)
		
		u.account.subscriptions.last.update(
			is_active: false,
			plan_amount: 0
			)
	end
	
	# 3. Log in, password reminders
	#---------------------------------------------------------------------------
	def login
		default_frame_eng
		redirect_to edit_user_path(current_user) unless current_user.nil?
	end
	
	def entrar
		default_frame_es
		
		if current_user.nil?
			render "users/login"
		else
			redirect_to edit_user_path(current_user)
		end
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
		# If user's login doesn't work, send them to the login page
			if user.nil? || user.sitelanguage == 1
				redirect_to "/login"
				flash[:tryagain] = "Try again…"
			else 
				redirect_to "/entrar"
				flash[:tryagain] = "Inténtelo de nuevo…"
			end
			
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
			@users = User.all.count
			
			@authors = User.authors.order("updated_at DESC")
			@superpatrons  = User.patrons.where('level_amount > ?', 2500)
			@patrons  = User.patrons.limit(20).order("updated_at DESC")
			@readers = User.readers.limit(20).order("updated_at DESC")
			
			@readerscount = User.readers.count
			@patronscount = User.patrons.count

			@patrons_subscription = User.patrons.where.not(subscription_id: nil)
			@patrons_no_subscription = User.patrons.where(subscription_id: nil)
			@patrons_uptodate = User.patrons.uptodate
			@patrons_declined = User.patrons.declined
			@patrons_cancelled = User.patrons.cancelled
			
			@nil_level = User.where(level_amount: nil)
			@nil_read_date = User.where(can_read_date: nil)
			@nil_frame = User.where(frame_id: nil)
			@nil_status = User.where(status: nil)
			@problems = @nil_status || @nil_level || @nil_read_date || @nil_frame
			
			@patrons_0 = User.patrons.where(level_amount: 0)
			@patrons_below_5 = User.patrons.where(level_amount: 1..499)
			@patrons_5 = User.patrons.where(level_amount: 500)
			@patrons_5_10 = User.patrons.where(level_amount: 501..999)
			@patrons_10 = User.patrons.where(level_amount: 1000)
			@patrons_10_25 = User.patrons.where(level_amount: 1001..2499)
			@patrons_25 = User.patrons.where(level_amount: 2500)
			@patrons_above_25 = User.patrons.where('level_amount > ?', 2501)
			
			@nil_level.each do |u|
				u.update(level_amount: 0)
			end
			
			@nil_read_date.each do |u|
				u.update(can_read_date: Date.yesterday.to_datetime)
			end
			
			@nil_frame.each do |u|
				u.update(frame_id: 1)
			end
			
			if params[:search]
				search_string = params[:search]
				@search_results = User.all.where("email LIKE ?", "%#{search_string}%").order("created_at DESC")
			end
			
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
	
	def account_boss_adds_user
		@user = User.find(params[:id])
		owner = @user
		user = User.find_by(email: params[:email_for_server])
		desired_level_amount = params[:level_amount].to_i
		account = Account.find(params[:account_id])
		subscription = Subscription.find(params[:subscription_id])
		
		how_much_left = Patrons::CalculateSubscriptionAmounts.process(subscription)
		is_it_enough = how_much_left["remaining"] - desired_level_amount
		
		case
			when is_it_enough < 0 
				level_amount = 0
			when is_it_enough >= 0
				level_amount = desired_level_amount
		end
		
		if user.nil?
			user = Patrons::CreateNewUser.process(params)
			Patrons::AddAccountMember.process(user, account, owner)
			Patrons::UpdateLevelAmount.process(user, level_amount)
			Patrons::AddUserToSubscription.process(user, subscription)
			puts "New user added..."
		elsif user.account_id == @user.account_id
			Patrons::UpdateLevelAmount.process(user, level_amount)
			Patrons::AddUserToSubscription.process(user, subscription)
			puts "Existing account user added to subscription..."
		else
			puts "You can't add that user..."
		end
		
		redirect_to edit_user_path(@user)
		flash[:success] = "New group member added."
	end
	
	def unlink_subscription_member
		u = User.find(params[:id])
		account = u.account
		owner = User.find_by(account_id: account.id, account_role: 1)
		
		Patrons::UnlinkSubscriptionMember.process(u)
		redirect_to edit_user_path(owner)
		flash[:success] = "Group member unlinked."
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
	
	def check_account_subscription(user)
		puts "Have arrived at method..."
		
		if !user.account.subscriptions.any?
		elsif user.account.subscriptions.last
			how_much_left = Patrons::CalculateSubscriptionAmounts.process(user.account.subscriptions.last)
			@members = user.account.subscriptions.last.users
			@subscription_spent = how_much_left["spent"]
			@subscription_remaining = how_much_left["remaining"]
		else end
			
		@unassigned_members = @user.account.users.where(subscription_id: "")
		@empty_invoices = @user.account.invoices.where('invoice_customer_name=? OR invoice_customer_tax_id=? OR invoice_customer_address=?', "", "", "")
		@payments = @user.account.payments.order("created_at DESC, id DESC")
	end
	
	# GET /users/1/edit
	def edit
		u = User.find(params[:id])
		
		if current_user.nil?
			puts "current_user nil cannot edit user"
			redirect_to root_url
		elsif current_user.status == 1
			@user = User.find(params[:id])
			set_language_frame(current_user.sitelanguage, current_user.frame.id)
			set_status(@user)
			check_account_subscription(@user)
		elsif User.find(params[:id]) != current_user
			redirect_to edit_user_path(current_user)
		elsif User.find(params[:id]) == current_user
			set_language_frame(current_user.sitelanguage, current_user.frame.id)
			set_status(current_user)
			check_account_subscription(current_user)
		else
			puts "some other user edit problem"
			redirect_to root_url
		end
		
		rescue ActiveRecord::RecordNotFound
			if current_user.nil?
				redirect_to root_url
			else
				redirect_to edit_user_path(current_user)
			end
		
	end
	
	def update_level_amount
		u = User.find(params[:id])
		la = params[:user][:level_amount].to_i
		account = u.account
		owner = User.find_by(account_id: account.id, account_role: 1)
		
		puts owner
		puts owner.email
		
		how_much_left = Patrons::CalculateSubscriptionAmounts.process(account.subscriptions.last)
		subscription_remaining = how_much_left["remaining"]
		
		if (subscription_remaining + u.level_amount) >= la
			u.update(
				level_amount: la, 
				status: 2
				)
		else 
			puts "Not possible..."	
		end
		
		redirect_to edit_user_path(owner)
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
		
		new_email = params[:user][:changing_email_to]
		
		if new_email.present?
			user = User.find_by(email: new_email)
			
			if user.nil?
				Patrons::ChangeEmailLink.process(new_email, current_user)
				
				case current_user.sitelanguage when 1
					message = "Check your email inbox..."
				when 2
					message = "Mire su buzón de correo..."
				end
				flash[:success] = message
			else
			end
		else end
		
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
			params.require(:user).permit(
				:account_id, :subscription_id, :address_name, :address_street, :address_postcode, :address_country, 
				:frame_id, :account_role, :country_id, :email, :changing_email_to, :email_confirmed, :emails, :emaillanguage, :level_amount, :password, 
			:password_confirmation, :password_digest, :password_reset_token, :password_reset_sent_at, :status, :sitelanguage, :confirm_token, :can_read, :can_read_date, :article_from_server
			)
		end
end