module Patrons
    class AddAccountMember
        def self.process(user, account, owner)
        
        user.update(
            account_id: account.id,
            account_role: 2,
            status: 2
            )
            
        user
        
        UserMailer.added_to_account(user, owner).deliver_now

        end
    end
end