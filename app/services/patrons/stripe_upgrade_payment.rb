module Patrons
    class StripeUpgradePayment
        def self.process(subscription, new_base_amount, new_tax_amount, new_total_amount, upgrade_base_amount, upgrade_tax_amount, upgrade_total_amount)
		
		# generates payment intent and attempts to process the payment straight away...
		payment_intent = Stripe::PaymentIntent.create({
			payment_method: subscription.account.stripe_payment_method,
			customer: subscription.account.stripe_customer_id,
			amount: upgrade_total_amount,
			currency: "eur",
			confirm: true,
			off_session: true
		})
		
		# create the payment on TSR, with whatever the response is from Stripe
		payment = Payment.create!(
			account_id: subscription.account_id,
			subscription_id: subscription.id,
			payment_type: "increase",
			base_amount: upgrade_base_amount,
			vat_amount: upgrade_tax_amount,
			total_amount: upgrade_total_amount,
			payment_method: payment_intent.payment_method,
			external_payment_id: payment_intent.id,
			external_payment_status: payment_intent.status
			)
		
		subscription.update(
            plan_amount: new_base_amount,
            vat_amount: new_tax_amount,
            total_amount: new_total_amount,
            last_payment_date: DateTime.now,
	        next_payment_date: DateTime.now + 1.month
            )

        if payment.external_payment_status == "succeeded"
        	Patrons::SuccessfulPayment.process(payment, payment.payment_method)
        else
        	Patrons::FailedPayment.process(payment)
        end

        end
    end
end