module Patrons
    class AddUserToSubscription
        def self.process(user, subscription)

        user.update(
            subscription_id: subscription
            )
            
        user

        end
    end
end