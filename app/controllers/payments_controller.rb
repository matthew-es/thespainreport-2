class PaymentsController < ApplicationController
	before_action :set_payment, only: [:show, :edit, :update, :destroy]
	skip_before_action :verify_authenticity_token, only: :stripe_webhook
	protect_from_forgery :except => :stripe_webhook
	
	def pay
		Stripe.api_key = 'sk_test_FVIuGU1W0mHIFIgS4uxtNJB5'
		
		@setup_intent = Stripe::SetupIntent.create({
			usage: 'off_session'
		})
	end
	
	def pagar
		Stripe.api_key = 'sk_test_FVIuGU1W0mHIFIgS4uxtNJB5'
		
		@setup_intent = Stripe::SetupIntent.create({
			usage: 'off_session'
		})
	end
	
	def stripe_first_payment
		Stripe.api_key = 'sk_test_FVIuGU1W0mHIFIgS4uxtNJB5'
		
		# create new Stripe customer, add new payment method, set default payment method
		@customer = Stripe::Customer.create({
			email: params[:email_for_server],
			payment_method: params[:pm_for_server],
			invoice_settings: {default_payment_method: params[:pm_for_server]}
		})
		
		# charge new Stripe customer for first payment
		@first_payment = Stripe::PaymentIntent.create({
			amount: 1000,
			currency: 'eur',
			customer: @customer,
			payment_method: @customer.invoice_settings.default_payment_method,
			off_session: true,
			confirm: true
		})
		
		# create TSR user, role to Patron, add Stripe customer_id
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
		
		# create TSR payment method, attach to TSR user
		
		# create TSR invoice for Patron, with Tax Rate
		
		# create TSR payment from Patron for invoice
		
	end
	
	def stripe_next_payments
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
		@payments = Payment.all
	end

	# GET /payments/1
	# GET /payments/1.json
	def show
	end

	# GET /payments/new
	def new
		@payment = Payment.new
	end

	# GET /payments/1/edit
	def edit
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
			params.fetch(:payment, {})
		end
end
