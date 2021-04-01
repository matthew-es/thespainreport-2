module Patrons
    class CreateNewSubscription
        def self.process(user, account, frame)

		subscription = Subscription.create!(
			account_id: account.id,
			plan_amount: 2500,
			frame_id: frame.id,
			is_active: true,
			next_payment_date: Time.zone.now + 30.days
			)
		
		user.update(
			subscription_id: subscription.id
			)

		user
        end
    end
end