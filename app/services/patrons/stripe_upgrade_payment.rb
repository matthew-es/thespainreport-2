module Patrons
    class StripeUpgradePayment
        def self.process(subscription, new_base_amount, new_tax_amount, new_total_amount, upgrade_base_amount, upgrade_tax_amount, upgrade_total_amount)
			
			begin
			payment_intent = Stripe::PaymentIntent.create({
				payment_method: subscription.account.stripe_payment_method,
				customer: subscription.account.stripe_customer_id,
				amount: upgrade_total_amount,
				currency: "eur"
			})
			
			puts "STRIPE PAYMENT INTENT CREATE IS: " + payment_intent["id"].to_s
			
			payment = Payment.create!(
				account_id: subscription.account_id,
				subscription_id: subscription.id,
				payment_type: "increase",
				base_amount: upgrade_base_amount.to_i,
				vat_amount: upgrade_tax_amount.to_i,
				total_amount: upgrade_total_amount.to_i,
				payment_method: payment_intent["payment_method"],
				external_payment_id: payment_intent["id"],
				external_payment_status: payment_intent["status"],
				status: "problem"
				)
			
			puts "TSR PAYMENT IS: " + payment.id.to_s
			
			Patrons::SubscriptionUpgrade.process(subscription, new_base_amount, new_tax_amount, new_total_amount)
			
			puts "SUBSCRIPTION UPDATED..."
			
			payment_intent_2 = Stripe::PaymentIntent.confirm(payment.external_payment_id, {off_session: true})
			
			puts "STRIPE PAYMENT INTENT 2 CONFIRM IS: " + payment_intent_2["id"].to_s
			
			payment.update(external_payment_status: payment_intent_2["status"])
			
			puts "STRIPE PAYMENT INTENT 2 CONFIRM STATUS: " + payment_intent_2["status"].to_s
			
	        if payment.external_payment_status == "succeeded"
	        	Patrons::SuccessfulPayment.process(payment, payment_intent.payment_method)
	        else
	        	puts "FAILING AFTER LOOKING AT EXTERNAL PAYMENT STATUS...."
	        	
	        	Patrons::FailedPayment.process(payment)
	        	Patrons::SubscriptionStop.process(subscription)
	        end
	        
	        rescue
	        	puts "FAILING STRAIGHT AFTER STRIPE ATTEMPT..."
	        	
	        	Patrons::FailedPayment.process(payment)
	        	Patrons::SubscriptionStop.process(subscription)
	        end

        end
    end
end