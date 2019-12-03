class PaymentsController < ApplicationController
	before_action :set_payment, only: [:show, :edit, :update, :destroy]
	
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
	
	def pay
		how_much
		
		@frame = Frame.find_by(link_slug: params[:slug])
		if @frame.nil?
			@frame = Frame.find_by(link_slug: "guarantee")
		end
		@frame_article = (@frame.language_id == 1)
		@frametranslation = @frame.translations.where(language_id: 1).first
		@frameoriginal = @frame.original
			
		@article_id = 2
		
		unless current_user.nil? || !current_user.account.present? || !current_user.account.stripe_payment_method.present?
			@existing_pm = Stripe::PaymentMethod.retrieve(current_user.account.stripe_payment_method)
			@existing_pm_brand = @existing_pm.card.brand
			@existing_pm_last4 = @existing_pm.card.last4
			@existing_pm_month = @existing_pm.card.exp_month
			@existing_pm_year = @existing_pm.card.exp_year
		end
	end
	
	def pagar
		how_much
		
		@frame = Frame.find_by(slug: params[:slug])
		if @frame.nil?
			@frame = Frame.find_by(slug: "garantizar")
		end
		@article_id = 2
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
			status: 2,
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
		
		@account.update(
			user_id: @user.id
			)
	end
	
	# Stripe payments
	# Setup, check customer, create new customer with card, calculate amount, first payment
	def stripe_get_payment_intent
		@payment_intent = Stripe::PaymentIntent.create({
			amount: 1000,
			currency: "eur"
		})
		
		Payment.create!(
			total_amount: @payment_intent.amount,
			external_payment_id: @payment_intent.id,
			external_payment_status: @payment_intent.status
			)
		
		@setup_intent = Stripe::SetupIntent.create({
			usage: "off_session"
			})
		
		render json: { secret: @setup_intent.client_secret, payment_intent: @payment_intent.id, setup_intent: @setup_intent.id }, status: 200
	end
	
	def check_user
		if current_user.nil?
			@user = User.find_by(email: params[:email_for_server])
		else
			@user = current_user
		end
	end
	
	# Does the user exist? Is the user the current user? Does he already have an account?
	def stripe_credit_card
		check_user
		
		if !@user.nil?
			if !current_user.nil? && current_user == @user
				if @user.account_id.present?
					@account = @user.account
					if @account.stripe_customer_id.present?
						@customer = @account.stripe_customer_id
						if @account.stripe_payment_method.present?
							@payment_method = @account.stripe_payment_method
							@card_country = @account.stripe_payment_method_card_country
							@residence_country = @account.residence_country
							stripe_calculate_total_amount_existing
						else
							add_stripe_payment_method
							stripe_calculate_total_amount
						end
					else
						new_stripe_customer
						stripe_calculate_total_amount
					end	
				else
					tsr_new_account
					new_stripe_customer
					stripe_calculate_total_amount
				end
			else
				payment_intent = params[:stripe_payment_intent_for_server]
				Stripe::PaymentIntent.cancel(payment_intent, {cancellation_reason: "abandoned"})
				@payment = Payment.find_by(external_payment_id: payment_intent)
				@payment.update(
					external_payment_status: "canceled"
					)
				
				PaymentError.create!(
					payment_id: @payment.id,
					payment_error_object: "check_if_user",
					payment_error_status: "not-logged-in",
					payment_error_code: "No code",
					payment_error_message: "Exsting user, not logged in",
					payment_error_source: "server-action-not-logged-in"
					)
			
				render json: {message: "You need to log in first…"}, status: 499
			end
		else
			tsr_new_user_patron
			tsr_new_account
			new_stripe_customer
			stripe_calculate_total_amount
		end
	end
	
	def stripe_calculate_total_amount_existing
		@plan_amount = params[:plan_amount_for_server] 
		@ip_country = params[:ip_country_code_for_server]
		
		eu_vat_logic
		
		@payment_intent = Stripe::PaymentIntent.create(
			amount: @total_amount,
			currency: "eur",
			customer: @customer,
			payment_method: @payment_method
			)
		
		@payment = Payment.create(
			total_amount: @total_amount,
			account_id: @account.id,
			external_payment_id: @payment_intent.id,
			payment_method: @payment_method,
			card_country: @card_country
			)
		
		render json: {plan_amount: @plan_amount.to_f, vat_country: @vat_country, vat_rate: @vat_rate.to_f, vat_amount: @vat_amount, total_amount: @total_amount}, status: 200
	end
	
	def stripe_calculate_total_amount
		check_user
		
		@account = @user.account
		
		@plan_amount = params[:plan_amount_for_server]
		@ip_country = params[:ip_country_code_for_server]
		@residence_country = params[:residence_country_code_for_server]
		@card_country = @account.stripe_payment_method_card_country
		@payment_method = @account.stripe_payment_method
		@payment_intent_for_server = params[:stripe_payment_intent_for_server]
		
		eu_vat_logic
		
		@payment_intent = Stripe::PaymentIntent.update(@payment_intent_for_server, {
			amount: @total_amount,
			customer: @account.stripe_customer_id,
			payment_method: @payment_method
			})
			
		@payment = Payment.find_by(external_payment_id: @payment_intent_for_server)
		@payment.update(
			total_amount: @total_amount,
			account_id: @account.id,
			payment_method: @payment_method,
			card_country: @card_country
			)
		    
		render json: {plan_amount: @plan_amount.to_f, vat_country: @vat_country, vat_rate: @vat_rate.to_f, vat_amount: @vat_amount, total_amount: @total_amount}, status: 200
	end
	
	def eu_vat_logic
		if (@card_country != @residence_country) && (@card_country != @ip_country) && (@residence_country == @ip_country)
			@vat_country = @residence_country
		else
			@vat_country = @card_country
		end
		
		@vat_rate = Country.find_by(country_code: @vat_country).tax_percent
		vat_calc = @plan_amount.to_f * @vat_rate
		total_calc = @plan_amount.to_f + vat_calc
		
		@vat_amount = vat_calc.round
		@total_amount = total_calc.round
		
		@account.update(
		    vat_country: @vat_country,
		    residence_country: @residence_country
		    )
	end
	
	def new_stripe_customer
		current_user.nil? ? @email = params[:email_for_server] : @email = current_user.email
		
		@customer = Stripe::Customer.create({
			email: @email,
			payment_method: params[:stripe_pm_for_server],
			invoice_settings: {default_payment_method: params[:stripe_pm_for_server]},
			expand: ['invoice_settings.default_payment_method']
		})
	
		@stripe_to_account = Account.find_by(id: @user.account.id)
		@stripe_to_account.update(
			stripe_customer_id: @customer.id,
			stripe_payment_method: @customer.invoice_settings.default_payment_method.id,
			stripe_payment_method_card_country: @customer.invoice_settings.default_payment_method.card.country,
			stripe_payment_method_expiry_reminder: Time.gm(@customer.invoice_settings.default_payment_method.card.exp_year, @customer.invoice_settings.default_payment_method.card.exp_month-1)
			)
	end
	
	def add_stripe_payment_method
		@payment_method = params[:stripe_pm_for_server]
		@customer = Stripe::Customer.update(@account.stripe_customer_id, {
			email: params[:email_for_server],
			payment_method: @payment_method,
			invoice_settings: {default_payment_method: @payment_method}
		})
	end
	
	def stripe_first_payment
		check_user
		
		@account = @user.account
		@account_id = @account.id
		@residence_country = @account.residence_country
		@card_country = @account.stripe_payment_method_card_country
		@vat_country = @account.vat_country
		
		@ip_address = params[:ip_address_for_server]
		@ip_country = params[:ip_country_code_for_server]
		@plan_amount = params[:plan_amount_for_server]
		@vat_rate = Country.find_by(country_code: @vat_country).tax_percent
		@vat_amount = params[:vat_amount_for_server]
		@total_amount = params[:total_amount_for_server]
		@payment = Payment.where(account_id: @account_id).last
		
		@time = Time.zone.now
		@frequency = "month"
		@time_next = case @frequency
			when "month" then @time.to_datetime >> 1
			when "week" then @time.to_datetime + 7.days
		end
		
		begin
			@subscription = Subscription.create(
				account_id: @account_id,
				residence_country: @residence_country,
				ip_address: @ip_address,
				ip_country: @ip_country,
				card_country: @card_country,
				plan_amount: @plan_amount,
				vat_country: @vat_country,
				vat_rate: @vat_rate,
				vat_amount: @vat_amount,
				total_amount: @total_amount,
				article_id: params[:article_id_for_server],
				frame_id: params[:frame_id_for_server],
				frame_link_slug: params[:frame_link_slug_for_server],
				frame_emotional_quest_action: params[:frame_emotional_quest_action_for_server],
				frame_money_word_singular: params[:frame_money_word_singular_for_server],
				frame_button_cta: params[:frame_button_cta_for_server],
				referrer_url: params[:referrer_for_server],
				last_payment_date: @time,
				next_payment_date: @time_next
				)
			
			@invoice = Invoice.create(
				account_id: @account_id,
				subscription_id: @subscription.id,
				plan_amount: @subscription.plan_amount,
				tax_percent: @subscription.vat_rate,
				tax_amount: @subscription.vat_amount,
			    total_amount: @subscription.total_amount
				)
			
			@payment.update(
				subscription_id: @subscription.id,
				invoice_id: @invoice.id
				)
			
			@stripe_payment = Stripe::PaymentIntent.confirm(@payment.external_payment_id)
			case @stripe_payment.status
				when "requires_action"
					PaymentError.create!(
						payment_id: @payment.id,
						payment_error_object: @stripe_payment.object,
						payment_error_status: @stripe_payment.status,
						payment_error_code: @stripe_payment.last_payment_error.decline_code,
						payment_error_message: "SCA confirmation required for this payment",
						payment_error_source: "server-action-stripe-confirm-payment-intent"
						)
					render json: {message: "Your bank wants you to re-confirm this specific payment. Please click \"re-confirm\" ", secret: @stripe_payment.client_secret}, status: 499
				when "succeeded"
			end
			
			if @account.total_support.nil?
				@account.total_support = 0
			end
			@new_total_support = @account.total_support + @subscription.plan_amount
			@account.update!(
		    total_support: @new_total_support
		    )
		    
		    if @account.payments.count > 1
				render json: {message: ""}, status: 200
			else
				render json: {message: ""}, status: 201
			end
			
		rescue Stripe::CardError => e
			@payment = @account.payments.last
			@payment.update(
				external_payment_id: e.error.payment_intent.id
				)
			
			PaymentError.create(
				payment_id: @payment.id,
				payment_error_object: "No object",
				payment_error_status: "Error",
				payment_error_code: "No code",
				payment_error_message: e.error.message,
				payment_error_source: "server-action-stripe-card-error"
				)
			render json: {message: "Problem with your payment. Your card has not been charged. Check your email now to fix it."}, status: 400
		rescue
			@payment = @account.payments.last
			PaymentError.create(
				payment_id: @payment.id,
				payment_error_object: "None",
				payment_error_status: "None",
				payment_error_code: "None",
				payment_error_message: "Generic server error.",
				payment_error_source: "server-action"
				)
			render json: {message: "A problem has ocurred. Your card has not been charged. Please reload the page and try again."}, status: 400
		end
	end

	
	def stripe_payment_log_details
		@user = User.find_by_email(params[:email_for_server])
		@account = @user.account
		@vat_rate = Country.find_by(country_code: @account.vat_country).tax_percent
		
		begin
			@subscription = Subscription.create(
				account_id: @account.id,
				ip_address: params[:ip_address_for_server],
				ip_country: params[:ip_country_code_for_server],
				card_country: @account.stripe_payment_method_card_country,
				residence_country: @account.residency_country,
				vat_country: @account.vat_country,
				plan_amount: params[:plan_amount_for_server],
				vat_rate: @vat_rate,
				vat_amount: params[:vat_amount_for_server],
				total_amount: params[:total_amount_for_server],
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
				external_payment_id: @stripe_payment.id,
				payment_method: @account.stripe_payment_method,
				card_country: @subscription.card_country,
				total_amount: @invoice.total_amount,
				account_id: @account.id,
				invoice_id: @invoice.id,
				subscription_id: @subscription.id
				)
		rescue
			render :json => {:error => "Some problem has ocurred. Don't worry, your card has not been charged. Please contact matthew@thespainreport.es"}, :status => 400
		end
	end
	
	def stripe_confirm_payment
		
	end

	def stripe_next_payments
	end
	
	def stripe_webhook
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
					@payment = Payment.find_by(external_payment_id: event.data.object.id)
					@payment_status = event.data.object.status
					if @payment.nil?
						
					else
						@payment.update(
							external_payment_status: @payment_status
							)
					end
					PaymentMailer.payment_success(@payment_status).deliver_now
				when 'payment_intent.payment_failed'
					case event.data.object.status
						when 'requires_payment_method'
							puts 'Add a payment method…'
							puts event.data.object.id
						when 'requires_confirmation'
							puts 'You need to confirm this payment…'
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
		elsif current_user.status == 1
			@payments = Payment.all.order('created_at DESC')
		else
			redirect_to root_url
		end
	end

	# GET /payments/1
	# GET /payments/1.json
	def show
		if current_user.nil? 
			redirect_to root_url
		elsif current_user.status == 1
			
		else
			redirect_to root_url
		end
	end

	# GET /payments/new
	def new
		if current_user.nil? 
			redirect_to root_url
		elsif current_user.status == 1
			@payment = Payment.new
		else
			redirect_to root_url
		end
	end

	# GET /payments/1/edit
	def edit
		if current_user.nil? 
			redirect_to root_url
		elsif current_user.status == 1
			
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
			params.require(:payment).permit(:card_country, :external_payment_error, :external_payment_id, :external_payment_status, :total_amount, :payment_method, :account_id, :invoice_id, :subscription_id)
		end
end