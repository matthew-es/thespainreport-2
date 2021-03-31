module Patrons
    class ChangeEmailLink
        def self.process(new_email, user)
		
		UserMailer.change_email_link(new_email, user).deliver_now

        end
    end
end