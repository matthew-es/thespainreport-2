module Patrons
    class StripeSetupIntentCreate
        def self.process()
		
		setup_intent = Stripe::SetupIntent.create({
			usage: "off_session"
			})
			
		setup_intent

        end
    end
end