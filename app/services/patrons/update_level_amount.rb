module Patrons
    class UpdateLevelAmount
        def self.process(user, level_amount)

        user.update(
            level_amount: level_amount
            )
            
        user

        end
    end
end