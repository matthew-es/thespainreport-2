module Patrons
    class CreateNewAccount
        def self.process(user)

		account = Account.create!(
			user_id: user.id,
			account_status: 4,
			account_status_date: Time.zone.now,
			conversation_status: 1,
			total_support: 0
			)
		
		user.update(
			account_id: account.id,
			account_role: 1,
			subscription_id: ""
			)

		account
        end
    end
end