module Patrons
    class AddUserToSubscription
        def self.process(user, subscription)

        user.update(
            subscription_id: subscription.id
            )
            
        user

        end
    end
end