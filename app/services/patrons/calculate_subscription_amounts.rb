module Patrons
    class CalculateSubscriptionAmounts
        def self.process(subscription)
            
            puts subscription
            
    		subscription_total = subscription.plan_amount
    		subscription_spent_per_user = []
    		subscription.users.each do |u|
    			subscription_spent_per_user << u.level_amount
    		end
    		
    		puts subscription_total
    		
    		subscription_spent = subscription_spent_per_user.compact.sum
    		subscription_remaining = subscription_total - subscription_spent
    		
    		if subscription_remaining >= 2500
    			options_top = true
    		elsif subscription_remaining.between?(1000, 2499)
    			options_middle = true
    		elsif subscription_remaining.between?(500, 999)
    			options_bottom = true
    		else end
    		
    		{"spent" => subscription_spent, "remaining" => subscription_remaining, "options_top" => options_top, "options_middle" => options_middle, "options_bottom" => options_bottom}
    		
        end
    end
end