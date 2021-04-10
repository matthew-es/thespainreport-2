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
		@frame = Frame.find_by(link_slug: params[:slug])
		if @frame.nil?
			@frame = Frame.find_by(link_slug: "guarantee")
		end
		set_language_frame(1, @frame.id)
		set_status(current_user) unless current_user.nil?
		set_payment_method(current_user) unless current_user.nil?
		
		placeholders
		how_much
		@article_id = "0"
	end
	
	def pagar
		@frame = Frame.find_by(link_slug: params[:slug])
		if @frame.nil?
			@frame = Frame.find_by(link_slug: "garantizar")
		end
		set_language_frame(2, @frame.id)
		set_status(current_user) unless current_user.nil?
		set_payment_method(current_user) unless current_user.nil?

		placeholders
		how_much
		@article_id = "0"
	end
	
	
	def payment_messages
		case @language when "1"
			@success_first = "Well done! Your payment has succeeded. Welcome aboard. Please check your email now."
		when "2"
			@success_first = "¡Enhorabuena! Su pago se ha realizado con éxito. Bienvenido a bordo. Mire su correo electrónico"
		end
	end
	
	def repeat_payment
		Patrons::StripeRepeatPayment.process(@user.account.subscriptions.last)
	end
	
	
	def simulate_webhook
		payment = Payment.find(1475)
		account = Account.find(payment.account.id)
		user = User.find_by(account_id: account.id, account_role: 1)
		PaymentMailer.fix_problem(payment, user, user.sitelanguage).deliver_now
	end
	
	
	# Fix payment problems page, SCA, etc.
	def fix_problem
		# And now you need the actual page bit...
		@payment = Payment.find_by(external_payment_id: params[:id])
		
		if current_user.nil?
			
		elsif @payment.nil?
			redirect_to edit_user_path(current_user)	
		else
			puts @payment
			puts @payment.id
			payment_intent = Stripe::PaymentIntent.retrieve(@payment.external_payment_id)
			
			account = Account.find(@payment.account_id)
			puts account
			puts account.id
			
			@user = User.find_by(account_id: account.id, account_role: 1)
			puts @user
			set_language_frame(current_user.sitelanguage, current_user.frame.id)
			payment_method = Stripe::PaymentMethod.retrieve(account.stripe_payment_method)
			
			# Generate a test repeat payment.... 
			
			
			@client_secret = payment_intent["client_secret"]
			@pm_brand = payment_method["card"]["brand"]
			@pm_month = payment_method["card"]["exp_month"]
			@pm_year = payment_method["card"]["exp_year"]
			@pm_last4 = payment_method["card"]["last4"]
			
		end
	end
	
	def fix_problem_confirm_with_card
		puts "Ok. that works..."
		puts params[:stripe_payment_intent_for_server]
		puts params[:stripe_pm_for_server]
		
		payment_intent = params[:stripe_payment_intent_for_server]
		payment_method = params[:stripe_pm_for_server]
		
		payment = Payment.find_by(external_payment_id: payment_intent)
		
		Stripe::PaymentMethod.attach(payment_method, {
			customer: payment.account.stripe_customer_id
			
		})
		
		confirm_payment = Stripe::PaymentIntent.confirm(payment_intent, {
			payment_method: payment_method
		})
		
		puts "Little payment confirm method completed..."
	end
	
	# Basic empty Stripe setup and payment intent
	def stripe_get_payment_intent
		payment_intent = Patrons::StripePaymentIntentCreate.process()
		setup_intent = Patrons::StripeSetupIntentCreate.process()
		
		puts payment_intent
		puts setup_intent
		
		render json: { secret: setup_intent.client_secret, payment_intent: payment_intent.id, setup_intent: setup_intent.id }, status: 200
	end

	
	# Does the user exist? 
	def check_user
		if current_user.nil?
			@user = User.find_by(email: params[:email_for_server])
		else
			@user = current_user
		end
	end
	
	
	# Is the user the current user? Does he already have an account?
	def stripe_credit_card
		check_user
		
		if !@user.nil?
			if !current_user.nil? && current_user == @user
				@account = @user.account
				if @account.stripe_customer_id.present?
					@customer = @account.stripe_customer_id
					if @account.stripe_payment_method.present?
						entered_pm_from_stripe = Stripe::PaymentMethod.retrieve(params[:stripe_pm_for_server])
						entered_brand = entered_pm_from_stripe["card"]["brand"]
						entered_month = entered_pm_from_stripe["card"]["exp_month"]
						entered_year = entered_pm_from_stripe["card"]["exp_year"]
						entered_last4 = entered_pm_from_stripe["card"]["last4"]
						entered_country = entered_pm_from_stripe["card"]["country"]
						
						existing_pm_from_stripe = Stripe::PaymentMethod.retrieve(@account.stripe_payment_method)
						existing_brand = existing_pm_from_stripe["card"]["brand"]
						existing_month = existing_pm_from_stripe["card"]["exp_month"]
						existing_year = existing_pm_from_stripe["card"]["exp_year"]
						existing_last4 = existing_pm_from_stripe["card"]["last4"]
						existing_country = existing_pm_from_stripe["card"]["country"]
						
						if (existing_brand == entered_brand) && (entered_month == existing_month) &&  (entered_year == existing_year) && (entered_last4 == existing_last4) && (entered_country == existing_country)
							puts "Card is the same..."
						else
							puts "Updating with new card..."
							add_stripe_payment_method
						end

						stripe_calculate_total_amount
					else
						add_stripe_payment_method
						stripe_calculate_total_amount
					end
				else
					new_stripe_customer
					add_stripe_payment_method
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
			@user = Patrons::CreateNewUser.process(params)
			@account = Patrons::CreateNewAccount.process(@user)
			new_stripe_customer
			add_stripe_payment_method
			stripe_calculate_total_amount
		end
	end
	
	def new_stripe_customer
		current_user.nil? ? @email = params[:email_for_server] : @email = current_user.email
		
		new_customer = Stripe::Customer.create({
			email: @email
		})

		@account.update(
			stripe_customer_id: new_customer.id
			)
	end
	
	
	def add_stripe_payment_method
		new_payment_method = params[:stripe_pm_for_server]
		customer = @account.stripe_customer_id
	
		Stripe::PaymentMethod.attach(new_payment_method, {
			customer: customer
		})
		
		update_customer = Stripe::Customer.update(customer, {
			invoice_settings: {default_payment_method: new_payment_method},
			expand: ['invoice_settings.default_payment_method']
		})

		@account.update(
			stripe_payment_method: update_customer.invoice_settings.default_payment_method.id,
			stripe_payment_method_card_country: update_customer.invoice_settings.default_payment_method.card.country,
			stripe_payment_method_expiry_reminder: Time.gm(update_customer.invoice_settings.default_payment_method.card.exp_year, update_customer.invoice_settings.default_payment_method.card.exp_month-1)
			)
	end
	
	
	def stripe_calculate_total_amount
		check_user
		set_country
		payment_method = @account.stripe_payment_method
		
		plan_amount = params[:plan_amount_for_server]
		payment_intent = params[:stripe_payment_intent_for_server]
		
		ip_country = @ip_lookup_country
		puts "IP country is: " + ip_country
		residence_country = params[:residence_country_code_for_server]
		card_country = @account.stripe_payment_method_card_country
		
		if (card_country != residence_country) && (card_country != ip_country) && (residence_country == ip_country)
			vat_country = residence_country
		else
			vat_country = card_country
		end
		
		@account.update(
			vat_country: vat_country,
			residence_country: residence_country,
			ip_country: ip_country,
			invoice_account_name: params[:invoice_name_for_server],
			invoice_account_tax_id: params[:invoice_tax_id_for_server],
			invoice_account_address: params[:invoice_address_for_server]
			)

		country = Country.find_by(country_code: vat_country)
		
		if country.nil?
			vat_rate = 0
		else
			applicable_vat_country = Country.find_by(country_code: "ES")
			vat_rate = applicable_vat_country.tax_percent
		end
		
		vat_calc = plan_amount.to_f * vat_rate
		total_calc = plan_amount.to_f + vat_calc
		
		vat_amount = vat_calc.round
		total_amount = total_calc.round
		
		Stripe::PaymentIntent.update(payment_intent, {
			amount: total_amount,
			customer: @account.stripe_customer_id,
			payment_method: payment_method
			})
		
		@payment = Payment.find_by(external_payment_id: payment_intent)
		@payment.update(
			total_amount: total_amount,
			account_id: @account.id,
			payment_method: payment_method,
			card_country: card_country
			)

		render json: {email: @user.email, plan_amount: plan_amount.to_f, vat_country: applicable_vat_country, vat_rate: vat_rate.to_f, vat_amount: vat_amount, total_amount: total_amount}, status: 200
	end
	
	
	def stripe_first_payment
		check_user
		@language = params[:language_for_server]
		payment_messages
		
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
			
		if params[:subscription_for_server].empty?
			puts "Creating new subscription now..."
			
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
				article_from_server: params[:article_for_server],
				frame_id: params[:frame_for_server],
				frame_link_slug: params[:frame_link_slug_for_server],
				frame_emotional_quest_action: params[:frame_emotional_quest_action_for_server],
				frame_money_word_singular: params[:frame_money_word_singular_for_server],
				frame_button_cta: params[:frame_button_cta_for_server],
				last_payment_date: @time,
				next_payment_date: @time_next,
				is_active: true
				)
		elsif params[:subscription_for_server]
			puts "Updating subscription now..." + params[:subscription_for_server]

			@subscription = Subscription.find_by(id: params[:subscription_for_server])
			puts @subscription
			puts @subscription.id
			puts @subscription.plan_amount
			puts @plan_amount
			
			@subscription.update(
				residence_country: @residence_country,
				ip_address: @ip_address,
				ip_country: @ip_country,
				card_country: @card_country,
				plan_amount: @plan_amount,
				vat_country: @vat_country,
				vat_rate: @vat_rate,
				vat_amount: @vat_amount,
				total_amount: @total_amount,
				article_from_server: params[:article_for_server],
				frame_id: params[:frame_for_server],
				frame_link_slug: params[:frame_link_slug_for_server],
				frame_emotional_quest_action: params[:frame_emotional_quest_action_for_server],
				frame_money_word_singular: params[:frame_money_word_singular_for_server],
				frame_button_cta: params[:frame_button_cta_for_server],
				last_payment_date: @time,
				next_payment_date: @time_next,
				is_active: true
				)
		else
		end
		
		@payment.update(
			subscription_id: @subscription.id
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
				when "requires_payment_method"
					puts "Needs a credit card..."
				when "succeeded"
					puts "Payment succeeded..."
					Patrons::CreateInvoice.process(@payment)
			end
			
			if @account.total_support.nil?
				@account.total_support = 0
			end
			
			@new_total_support = @account.total_support + @subscription.plan_amount
			@account.update!(
				total_support: @new_total_support
			)
			
			if @subscription.plan_amount < 2500
				owner_level_amount = @subscription.plan_amount
			elsif @subscription.plan_amount >= 2500
				owner_level_amount = 2500
			else end
			
			@user.update(
				status: 2,
				subscription_id: @subscription.id,
				level_amount: owner_level_amount
				)
			
			if @account.payments.count > 0
				respond_to do |format|
					session[:user_id] = @user.id
					format.json { render json: {message: @success_first, url: edit_user_path(@user)}, status: 200 and return }
				end
				# render json: {message: @success_first}, status: 200 and return
			else
				render json: {message: ""}, status: 201 and return
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
		
		elsif @payment.account.user_id == current_user.id
		
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
			params.require(:payment).permit(:card_country, :external_payment_error, :external_payment_id, :external_payment_status, :status, :total_amount, :payment_method, :account_id, :invoice_id, :subscription_id)
		end
end