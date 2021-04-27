module Patrons
    class FailedPayment
        def self.process(payment)
        	
        	payment.update(status: "problem")
        	PaymentMailer.payment_problem(payment).deliver_now

        end
    end
end