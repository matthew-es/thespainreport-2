module Patrons
    class StripeRepeatPayment
        def self.process(subscription)
		
		# generates payment intent and attempts to process the payment straight away...
		payment_intent = Stripe::PaymentIntent.create({
			payment_method: subscription.account.stripe_payment_method,
			customer: subscription.account.stripe_customer_id,
			amount: subscription.total_amount,
			currency: "eur",
			confirm: true,
			off_session: true
		})
		
		# create the payment on TSR, with whatever the response is from Stripe
		payment = Payment.create!(
			account_id: subscription.account_id,
			subscription_id: subscription.id,
			payment_type: "repeat",
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