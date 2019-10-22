class PaymentsController < ApplicationController
	before_action :set_payment, only: [:show, :edit, :update, :destroy]
	skip_before_action :verify_authenticity_token, only: :stripe_webhook
	protect_from_forgery :except => :stripe_webhook
	
	def how_much
		if !params[:amount]
			@amount = 25
		elsif params[:amount].to_i.between?(0, 5)
			@amount = 5
		elsif params[:amount].to_i.between?(6, 300)
			@amount = params[:amount]
		elsif params[:amount].to_i > 300
			@amount = 300
		end
	end
	
	def stripe_api
		Stripe.api_key = 'sk_test_FVIuGU1W0mHIFIgS4uxtNJB5'
	end
	
	def stripe_setup_intent
		@setup_intent = Stripe::SetupIntent.create({
			usage: 'off_session',
			expand: ['payment_method.card']
		})
	end
	
	def pay
		how_much
		stripe_api
	end
	
	def pagar
		how_much
		stripe_api
		stripe_setup_intent
	end
	
	def ajax_test
		@setup_intent = Stripe::SetupIntent.create({
			usage: 'off_session'
		})
		@text = @setup_intent.client_secret
		
		respond_to do |format|
			format.json { render json: @text }
		end
	end
	
	def tsr_new_user_patron
		autopassword = 'L e @ 4' + SecureRandom.hex(32)
		generate_token = SecureRandom.urlsafe_base64.to_s
		@new_tsr_user = User.create!(
			email: params[:email_for_server],
			confirm_token: generate_token,
			password: autopassword,
			password_confirmation: autopassword,
			password_reset_sent_at: Time.zone.now,
			role: 2,
			sitelanguage: 1,
			emails: 1,
			emaillanguage: 1,
			email_confirmed: false
			)
	end
	
	def tsr_new_account
		@account = Account.create!(
		    account_status: 1,
		    conversation_status: 1,
		    account_status_date: Time.zone.now
		    )
		
		@user = User.find_by_email(params[:email_for_server])
		@user.update(
		    account_id: @account.id,
		    account_role: 1
		    )
	end
	
	def new_stripe_customer
		@customer = Stripe::Customer.create({
			email: params[:email_for_server],
			payment_method: params[:stripe_pm_for_server],
			invoice_settings: {default_payment_method: params[:stripe_pm_for_server]},
			expand: ['invoice_settings.default_payment_method']
		})
	
		@stripe_to_account = Account.find_by(id: @user.account.id)
		@stripe_to_account.update(
			stripe_customer_id: @customer.id,
			stripe_payment_method: @customer.invoice_settings.default_payment_method.id,
			stripe_payment_method_card_country: @customer.invoice_settings.default_payment_method.card.country
			)
	end
	
	def stripe_card_payment_and_details
		@user = User.find_by_email(params[:email_for_server])
		@account = @user.account
		
		@stripe_payment = Stripe::PaymentIntent.create({
			amount: params[:total_amount_for_server],
			currency: 'eur',
			customer: @account.stripe_customer_id,
			payment_method: @account.stripe_payment_method,
			off_session: true,
			confirm: true
		})

		@subscription = Subscription.create(
			account_id: @account.id,
			amount: params[:total_amount_for_server],
			ip_address: params[:ip_address_for_server],
			ip_country: params[:country_code_for_server],
			card_country: @account.stripe_payment_method_card_country,
			latest_paid_date: Time.zone.now
			)
		
		@invoice = Invoice.create(
			plan_amount: params[:plan_amount_for_server],
			tax_percent: params[:vat_percent_for_server],
			tax_amount: params[:vat_amount_for_server],
		    total_amount: @subscription.amount,
		    account_id: @account.id,
		    subscription_id: @subscription.id
			)

		@payment = Payment.create(
			card_country: @subscription.card_country,
			total_amount: @invoice.total_amount,
			payment_method: @account.stripe_payment_method,
			account_id: @account.id,
			invoice_id: @invoice.id,
			subscription_id: @subscription.id
			)
	end

	def stripe_calculate_total_amount
		plan_amount = params[:plan_amount_for_server]
		
		ip_country = params[:ip_country_code_for_server]
		residence_country = params[:residence_country_code_for_server]
		pm = Stripe::PaymentMethod.retrieve(params[:stripe_pm_for_server])
		card_country = pm.card.country

		puts card_country
		puts residence_country
		puts ip_country
		
		if (card_country != residence_country) && (card_country != ip_country) && (residence_country == ip_country)
			vat_country = residence_country
		else
			vat_country = card_country
		end
		puts vat_country
		
		vat_rate = Country.find_by(country_code: vat_country).tax_percent
		vat_amount = plan_amount.to_f * vat_rate
		total_amount = plan_amount.to_f + vat_amount
		
		puts plan_amount
		puts vat_rate
		puts vat_amount
		puts total_amount
		puts total_amount.round
		@vat_amount = vat_amount.round
		@total_amount = total_amount.round
		
		render json: {total: @total_amount, vat: @vat_amount}
	end
	
	def stripe_first_payment
		@total_amount = params[:total_amount]
		@user = User.find_by_email(params[:email_for_server])
		@account = @user.account
		
		@stripe_payment = Stripe::PaymentIntent.create({
			amount: @total_amount,
			currency: 'eur',
			customer: @account.stripe_customer_id,
			payment_method: @account.stripe_payment_method,
			off_session: true,
			confirm: true
		})
		
		render json: {total: "Well done…!"}
	end
	
	def stripe_confirm_payment
		Stripe.api_key = 'sk_test_FVIuGU1W0mHIFIgS4uxtNJB5'
		
		Stripe::PaymentIntent.update(
				  'pi_1FBPkVAKYHByLBAAEdqBzxrK',
				  {
				    customer: 'cus_FhX9I1R1mfKDks'
				  }
				)
		
		@payment_intent = Stripe::PaymentIntent.retrieve('pi_1FBPkVAKYHByLBAAEdqBzxrK')
		@user = "matthew@thespainreport.com"
		@payment_method = 'pm_1FC83OAKYHByLBAAtbpqh0VE'
	end

	def stripe_credit_card
		stripe_api
		@user = User.find_by(email: params[:email_for_server])
		
		if !@user.nil?
			if !current_user.nil? && current_user == @user
				if @user.account_id.present?
					if @user.account.stripe_customer_id.present?
						@customer = Stripe::Customer.retrieve(@user.account.stripe_customer_id)
						stripe_calculate_total_amount
					else
						new_stripe_customer
						stripe_card_payment_and_details
					end	
				else
					tsr_new_account
					new_stripe_customer
					stripe_card_payment_and_details
				end
			else
				redirect_to '/login'
				flash[:success] = "Please log in to continue."
			end
		else
			tsr_new_user_patron
			tsr_new_account
			new_stripe_customer
			stripe_calculate_total_amount
		end
	end
	
	def stripe_next_payments
	end
	
	def stripe_webhook
		Stripe.api_key = 'sk_test_FVIuGU1W0mHIFIgS4uxtNJB5'
		webhook_endpoint_secret = 'whsec_5IuCz8Ecp0PwQVMIXybJV9YtN0fqu1XV'
		webhook = request.raw_post
		webhook_header = request.env['HTTP_STRIPE_SIGNATURE']
	
		event = nil
		begin
			event = Stripe::Webhook.construct_event(
				webhook, webhook_header, webhook_endpoint_secret
			)
		rescue JSON::ParserError => e
			render :json => {:status => 400, :error => "Invalid payload"} and return
		rescue Stripe::SignatureVerificationError => e
			render :json => {:status => 400, :error => "Invalid signature"} and return
		end
		
		render :json => {:status => 200}
		
		begin
			case event.type
				when 'payment_intent.succeeded'
					puts 'Money in the bank…!'
					@payment = event.data.object.status
					PaymentMailer.payment_success(@payment).deliver_now
				when 'payment_intent.payment_failed'
					case event.data.object.status
						when 'requires_payment_method'
							puts 'Add a payment method…'
						when 'requires_confirmation'
							puts 'You need to confirm this…'
						when 'requires_action'
							puts 'SCA time…'
						else
							puts 'Needs something else…'
					end
				else
					puts "This was something else…"
			end
		rescue Exception => ex
		render :json => {:status => 400, :error => "Webhook failed"} and return
		end
		
	end

	
	# GET /payments
	# GET /payments.json
	def index
		if current_user.nil? 
			redirect_to root_url
		elsif current_user.role == 1
			@payments = Payment.all
		else
			redirect_to root_url
		end
	end

	# GET /payments/1
	# GET /payments/1.json
	def show
		if current_user.nil? 
			redirect_to root_url
		elsif current_user.role == 1
			
		else
			redirect_to root_url
		end
	end

	# GET /payments/new
	def new
		if current_user.nil? 
			redirect_to root_url
		elsif current_user.role == 1
			@payment = Payment.new
		else
			redirect_to root_url
		end
	end

	# GET /payments/1/edit
	def edit
		if current_user.nil? 
			redirect_to root_url
		elsif current_user.role == 1
			
		else
			redirect_to root_url
		end
	end

	# POST /payments
	# POST /payments.json
	def create
		@payment = Payment.new(payment_params)

		respond_to do |format|
			if @payment.save
				format.html { redirect_to @payment, notice: 'Payment was successfully created.' }
				format.json { render :show, status: :created, location: @payment }
			else
				format.html { render :new }
				format.json { render json: @payment.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT /payments/1
	# PATCH/PUT /payments/1.json
	def update
		respond_to do |format|
			if @payment.update(payment_params)
				format.html { redirect_to @payment, notice: 'Payment was successfully updated.' }
				format.json { render :show, status: :ok, location: @payment }
			else
				format.html { render :edit }
				format.json { render json: @payment.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /payments/1
	# DELETE /payments/1.json
	def destroy
		@payment.destroy
		respond_to do |format|
			format.html { redirect_to payments_url, notice: 'Payment was successfully destroyed.' }
			format.json { head :no_content }
		end
	end

	private
		# Use callbacks to share common setup or constraints between actions.
		def set_payment
			@payment = Payment.find(params[:id])
		end

		# Never trust parameters from the scary internet, only allow the white list through.
		def payment_params
			params.require(:payment).permit(:card_country, :total_amount, :payment_method, :account_id, :invoice_id, :subscription_id)
		end
end