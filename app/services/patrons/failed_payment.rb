module Patrons
    class FailedPayment
        def self.process(payment)
        	
        	payment.update(status: "problem")
        	PaymentMailer.payment_problem(payment).deliver_now
        	
        	admin_subject = "⚠️ " + " PROBLEM: " + payment.payment_type.upcase + " " + (ActiveSupport::NumberHelper.number_to_currency((payment.total_amount/100.to_f), unit: "€")).to_s + " from " + payment.account.user.email
			admin_message = ""
			PaymentMailer.payment_admin_message(admin_subject, admin_message).deliver_now
        end
    end
end