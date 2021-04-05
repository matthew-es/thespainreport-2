module Patrons
    class StripePaymentIntentCreate
        def self.process()
		
		payment_intent = Stripe::PaymentIntent.create({
			amount: 1000,
			currency: "eur"
		})
		
		Payment.create!(
			total_amount: payment_intent.amount,
			external_payment_id: payment_intent.id,
			external_payment_status: payment_intent.status
			)
		
		payment_intent

        end
    end
end