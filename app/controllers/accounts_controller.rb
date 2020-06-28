class AccountsController < ApplicationController
	before_action :set_account, only: [:show, :edit, :update, :destroy]

	# GET /accounts
	# GET /accounts.json
	def index
		if current_user.nil? 
			redirect_to root_url
		elsif current_user.status == 1
			@uptodate_accounts = Account.uptodate.limit(20).order('updated_at DESC')
			@declined_accounts = Account.declined.limit(20).order('updated_at DESC')
			@cancelled_accounts = Account.cancelled.limit(20).order('updated_at DESC')
			@free_accounts = Account.free.limit(20).order('updated_at DESC')
			
		else
			redirect_to root_url
		end
	end

	# GET /accounts/1
	# GET /accounts/1.json
	def show
		if current_user.nil? 
			redirect_to root_url
		elsif current_user.status == 1
			redirect_to edit_account_path(@account)
		else
			redirect_to root_url
		end
	end

	# GET /accounts/new
	def new
		if current_user.nil? 
			redirect_to root_url
		elsif current_user.status == 1
			@account = Account.new
		else
			redirect_to root_url
		end
		
		
	end
	
	def admin_modifies_accounts_and_users
		array2 = params[:email].split(/\r\n/)
		
		array2.each do |e|
			@user = User.find_by_email(e)
			
			if @user.present?
				
			else
				autopassword = 'L e @ 4' + SecureRandom.hex(32)
				generate_token = SecureRandom.urlsafe_base64.to_s
				
				new_user = User.create!(email: e,
					confirm_token: generate_token,
					password: autopassword,
					password_confirmation: autopassword,
					password_reset_token: generate_token,
					password_reset_sent_at: Time.zone.now,
					email_confirmed: 1
					)
				
				@user = new_user
			end
			
			
			if @user.account_id.nil? || !Account.find_by_id(@user.account_id).present?
				@account = Account.create!(
					account_status_date: Time.zone.now
					)
				
				@user.update(
					account_id: @account.id,
					account_role: 1
					)
			else
				@account = Account.find_by_id(@user.account_id)
			end
			
			admin_sets_account_settings
			admin_sets_user_settings
		end
		
		redirect_back(fallback_location: root_path)
	end
	
	def admin_sets_account_settings
		if params[:account_status].blank?
			new_account_status = @user.account.account_status
		else
			new_account_status = params[:account_status]
		end
		
		if params[:conversation_status].blank?
			new_conversation_status = @user.account.conversation_status
		else
			new_conversation_status = params[:conversation_status]
		end
		
		new_account_status_date = Time.zone.now
		
		@account.update(
			account_status: new_account_status,
			conversation_status: new_conversation_status,
			account_status_date: new_account_status_date
			)
	end
	
	def admin_sets_user_settings
		if params[:user_status].blank?
			new_status = @user.status
		else
			new_status = params[:user_status]
		end
		
		if params[:sitelanguage].blank?
			new_site_language = @user.sitelanguage
		else
			new_site_language = params[:sitelanguage]
		end
		
		if params[:emails].blank?
			new_emails = @user.emails
		else
			new_emails = params[:emails]
		end
		
		if params[:emaillanguage].blank?
			new_email_language = @user.emaillanguage
		else
			new_email_language = params[:emaillanguage]
		end
		
		if params[:level_amount].blank?
			new_level_amount = @user.level_amount
		else
			new_level_amount = params[:level_amount]
		end
		
		if params[:can_read].blank?
			new_can_read = @user.can_read
		else
			new_can_read = params[:can_read]
		end
		
		if @user.frame_id.nil?
			new_frame_id = 1
		else
			new_frame_id = @user.frame_id
		end
		
		@user.update(
			status: new_status,
			sitelanguage: new_site_language,
			emails: new_emails,
			emaillanguage: new_email_language,
			level_amount: new_level_amount,
			frame_id: new_frame_id,
			can_read: new_can_read
			)
		
	end
	
	
	
	# GET /accounts/1/edit
	def edit
		if current_user.nil? 
			redirect_to root_url
		elsif current_user.status == 1
			@accountowner = User.find_by(account_id: @account, account_role: 1)
		else
			redirect_to root_url
		end
	end

	# POST /accounts
	# POST /accounts.json
	def create
		@account = Account.new(account_params)

		respond_to do |format|
			if @account.save
				format.html { redirect_to @account, notice: 'Account was successfully created.' }
				format.json { render :show, status: :created, location: @account }
			else
				format.html { render :new }
				format.json { render json: @account.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT /accounts/1
	# PATCH/PUT /accounts/1.json
	def update
		respond_to do |format|
			if @account.update(account_params)
				format.html { redirect_to edit_account_path(@account), notice: 'Account was successfully updated.' }
				format.json { render :show, status: :ok, location: @account }
			else
				format.html { render :edit }
				format.json { render json: @account.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /accounts/1
	# DELETE /accounts/1.json
	def destroy
		@account.destroy
		respond_to do |format|
			format.html { redirect_to accounts_url, notice: 'Account was successfully destroyed.' }
			format.json { head :no_content }
		end
	end

	private
		# Use callbacks to share common setup or constraints between actions.
		def set_account
			@account = Account.find(params[:id])
		end

		# Never trust parameters from the scary internet, only allow the white list through.
		def account_params
			params.require(:account).permit(:user_id, :account_status, :account_status_date, :conversation_status, :residence_country, :stripe_customer_id, :stripe_payment_method, :stripe_payment_method_card_country, :vat_country, :total_support)
		end
end
