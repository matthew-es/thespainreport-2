module Patrons
    class StripeRepeatPayment
        def self.process(subscription)
		
		# generates payment intent and attempts to process the payment straight away...
		payment_intent = Stripe::PaymentIntent.create({
			payment_method: subscription.account.stripe_payment_method,
			customer: subscription.account.stripe_customer_id,
			amount: subscription.total_amount,
			currency: "eur",
			confirm: true
		})
		
		# create the payment on TSR, with whatever the response is from Stripe
		payment = Payment.create!(
			account_id: subscription.account_id,
			subscription_id: subscription.id,
			total_amount: payment_intent.amount,
			external_payment_id: payment_intent.id,
			external_payment_status: payment_intent.status
			)
		
		subscription.update(
            last_payment_date: DateTime.now,
	        next_payment_date: DateTime.now + 1.month
            )

        if payment.external_payment_status == "succeeded"
            Patrons::CreateInvoice.process(payment)
            
            payment.update(status: "paid")
            
			subscription.users.each do |u|
				u.update(
					status: 2,
					can_read_date: DateTime.now + 1.month
					)
			end
        else
        end

        end
    end
end