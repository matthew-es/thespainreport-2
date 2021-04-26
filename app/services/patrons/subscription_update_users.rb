module Patrons
    class SubscriptionUpdateUsers
        def self.process(subscription, amount)
            
            uc = subscription.users.count
            puts "UC is: " + uc.to_s
            
            a = amount.to_i
            puts "AMOUNT IS: " + a.to_s
            
            if subscription.plan_amount == amount
                subscription.users.each do |u|
                    u.update(status: 2, can_read_date: subscription.next_payment_date)
                end
            else
                subscription.users.each do |u|
        			if a >= (uc * 2500)
                        u.update(status: 2, can_read_date: subscription.next_payment_date, level_amount: 2500)
                    elsif a >= (uc * 1000)
                        u.update(status: 2, can_read_date: subscription.next_payment_date, level_amount: 1000)
                    elsif a >= (uc * 500)
                        u.update(status: 2, can_read_date: subscription.next_payment_date, level_amount: 500)
                    elsif a >= 2500
                    
                    elsif a >= 1000
                    
                    elsif a >= 500
                    
                    else
                        
                    end
        		end
            end
            
        end
    end
end