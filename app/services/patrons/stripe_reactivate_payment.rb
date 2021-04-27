module Patrons
    class StripeReactivatePayment
        def self.process(subscription)
        	
			payment_intent = Stripe::PaymentIntent.create({
				payment_method: subscription.account.stripe_payment_method,
				customer: subscription.account.stripe_customer_id,
				amount: subscription.total_amount,
				currency: "eur"
			})
			
			payment = Payment.create!(
				account_id: subscription.account_id,
				subscription_id: subscription.id,
				payment_type: "reactivate",
				base_amount: subscription.plan_amount,
				vat_amount: subscription.vat_amount,
				total_amount: payment_intent.amount,
				payment_method: payment_intent["payment_method"],
				external_payment_id: payment_intent["id"],
				external_payment_status: payment_intent["status"],
				status: "problem"
				)
			
			payment
		
        end
    end
end