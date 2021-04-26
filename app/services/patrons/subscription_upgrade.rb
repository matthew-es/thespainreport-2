module Patrons
    class SubscriptionUpgrade
        def self.process(subscription, new_base_amount, new_tax_amount, new_total_amount)
        
        subscription.update(
            is_active: true,
            plan_amount: new_base_amount,
            vat_amount: new_tax_amount,
            total_amount: new_total_amount,
	        reactivate_token: SecureRandom.urlsafe_base64.to_s
            )
        
        Patrons::SubscriptionUpdateUsers.process(subscription, new_base_amount)
            
        subscription

        end
    end
end