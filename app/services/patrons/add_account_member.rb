module Patrons
    class AddAccountMember
        def self.process(user, account)

        user.update(
            account_id: account,
            account_role: 2
            )
            
        user

        end
    end
end