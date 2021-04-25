module Patrons
    class StripeRepeatPayment
        def self.process(subscription)
		
		# First make sure a repeat payment has not already been issued today...
		if subscription.payments.last.created_at.today?
		
		else
			# generates payment intent and attempts to process the payment straight away...
			payment_intent = Stripe::PaymentIntent.create({
				payment_method: subscription.account.stripe_payment_method,
				customer: subscription.account.stripe_customer_id,
				amount: subscription.total_amount,
				currency: "eur",
				confirm: true,
				off_session: true
			})
			
			# create the immediate payment on TSR, so any actual payments do not repeat if there are any errors from this point onwards...
			payment = Payment.create!(
				account_id: subscription.account_id,
				subscription_id: subscription.id,
				payment_type: "repeat",
				status: "problem"
				)
			
			# now start updating everything...
			payment.update!(
				base_amount: subscription.plan_amount,
				vat_amount: subscription.vat_amount,
				total_amount: payment_intent.amount,
				payment_method: payment_intent.payment_method,
				external_payment_id: payment_intent.id,
				external_payment_status: payment_intent.status
				)
			
			subscription.update(
	            last_payment_date: DateTime.now,
		        next_payment_date: DateTime.now + 1.month
	            )
	
	        if payment.external_payment_status == "succeeded"
	        	Patrons::SuccessfulPayment.process(payment, payment_intent.payment_method)
	        else
	        	Patrons::FailedPayment.process(payment)
	        end
		
		end
		
        end
    end
end