module Patrons
    class UnlinkSubscriptionMember
        def self.process(user)
		
			user.update(
				subscription_id: ""
				)
	
			user
		
        end
    end
end