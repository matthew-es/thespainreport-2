module Patrons
    class StripeRepeatPayment
        def self.process(subscription)
        	
			begin
			payment_intent = Stripe::PaymentIntent.create({
				payment_method: subscription.account.stripe_payment_method,
				customer: subscription.account.stripe_customer_id,
				amount: subscription.total_amount,
				currency: "eur"
			})
			
			payment = Payment.create!(
				account_id: subscription.account_id,
				subscription_id: subscription.id,
				payment_type: "repeat",
				base_amount: subscription.plan_amount,
				vat_amount: subscription.vat_amount,
				total_amount: payment_intent.amount,
				payment_method: payment_intent["payment_method"],
				external_payment_id: payment_intent["id"],
				external_payment_status: payment_intent["status"],
				status: "problem"
				)
			
			payment_intent_2 = Stripe::PaymentIntent.confirm(payment.external_payment_id, {off_session: true})
			payment.update(external_payment_status: payment_intent_2["status"])
	
	        if payment.external_payment_status == "succeeded"
	        	Patrons::SuccessfulPayment.process(payment, payment_intent.payment_method)
	        	Patrons::SubscriptionRollover.process(subscription)
	        else
	        	Patrons::FailedPayment.process(payment)
	        	Patrons::SubscriptionStop.process(subscription)
	        end
	        
	        rescue
	        	Patrons::FailedPayment.process(payment)
	        	Patrons::SubscriptionStop.process(subscription)
	        end
		
        end
    end
end