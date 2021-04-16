module Patrons
    class FailedPayment
        def self.process(payment)
        	
        	payment.update(status: "problem")
        	payment.subscription.update(is_active: false)
        	PaymentMailer.payment_problem(payment).deliver_now

        end
    end
end