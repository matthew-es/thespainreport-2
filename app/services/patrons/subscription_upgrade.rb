module Patrons
    class SubscriptionUpgrade
        def self.process(subscription, new_base_amount, new_tax_amount, new_total_amount)
        
        puts "SUBSCRIPTION IS: " + subscription.id.to_s
        puts "NEW BASE AMOUNT IS: " + new_base_amount.to_s
        puts "NEW TAX AMOUNT IS: " + new_tax_amount.to_s
        puts "NEW TOTAL AMOUNT IS: " + new_total_amount.to_s
        
        subscription.update(
            is_active: true,
            plan_amount: new_base_amount,
            vat_amount: new_tax_amount,
            total_amount: new_total_amount,
	        reactivate_token: SecureRandom.urlsafe_base64.to_s
            )
        
        puts "UPDATED SUBSCRIPTION IS: " + subscription.id.to_s
        puts "UPDATED NEW BASE AMOUNT IS: " + subscription.plan_amount.to_s
        puts "UPDATED NEW TAX AMOUNT IS: " + subscription.vat_amount.to_s
        puts "UPDATED NEW TOTAL AMOUNT IS: " + subscription.total_amount.to_s
            
        subscription

        end
    end
end