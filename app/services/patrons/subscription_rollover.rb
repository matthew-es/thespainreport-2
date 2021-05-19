module Patrons
    class SubscriptionRollover
        def self.process(subscription, payment)

            subscription.update(
                is_active: true,
                last_payment_date: payment.created_at,
    	        next_payment_date: payment.created_at + 1.month,
    	        reactivate_token: SecureRandom.urlsafe_base64.to_s
                )
            
    		Patrons::SubscriptionUpdateUsers.process(subscription, subscription.plan_amount)
        
            subscription

        end
    end
end