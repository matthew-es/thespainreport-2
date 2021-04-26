module Patrons
    class SubscriptionStop
        def self.process(subscription)

        subscription.update(
            is_active: false,
            next_payment_date: DateTime.now
            )
        
        Patrons::SubscriptionUpdateUsers.process(subscription, subscription.plan_amount)
        
        subscription

        end
    end
end