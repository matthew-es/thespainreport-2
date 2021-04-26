module Patrons
    class SubscriptionDowngrade
        def self.process(subscription, new_base_amount, new_tax_amount, new_total_amount, extra_days)
            
        next_payment_date = DateTime.now + extra_days.to_i.days
        
		subscription.update(
			plan_amount: new_base_amount,
			vat_amount: new_tax_amount,
			total_amount: new_total_amount,
			next_payment_date: next_payment_date
		)
        
        Patrons::SubscriptionUpdateUsers.process(subscription, new_base_amount)
        
        subscription

        end
    end
end