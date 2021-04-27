module Patrons
    class SubscriptionStop
        def self.process(subscription)

        subscription.update(
            is_active: false
            )
        
        Patrons::SubscriptionUpdateUsers.process(subscription, subscription.plan_amount)
        
        subscription

        end
    end
end