class PaymentErrorsController < ApplicationController
    
    def create_payment_error
        @payment = Payment.find_by(external_payment_id: params[:stripe_payment_intent_for_server])
        @payment_error = PaymentError.create(
			payment_id: @payment.id,
			payment_error_object: params[:payment_error_object],
			payment_error_status: params[:payment_error_status],
			payment_error_code: params[:payment_error_code],
			payment_error_message: params[:payment_error_message],
			payment_error_source: "client-browser"
			)
		
		case @payment_error.payment_error_code
		    when "insufficient_funds"
		        render json: {message: "Not enough money on that card. Please add more funds and try again, or use a different card."}, status: 477
		    else 
		        render json: {message: "That card does not work. Please use a different one."}, status: 400
		end
    end
    
end