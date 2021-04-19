module Patrons
    class SuccessfulPayment
        def self.process(payment)
            payment.update(status: "paid")
            
            payment.subscription.update(is_active: true, next_payment_date: DateTime.now + 1.month)
			
			payment.subscription.users.each do |u|
				u.update(
					status: 2,
					can_read_date: payment.subscription.next_payment_date
					)
			end
			
		    Patrons::CreateInvoice.process(payment) unless Invoice.where(payment_id: payment.id, invoice_operation: "payment").count > 0
			
			PaymentMailer.payment_success(payment).deliver_now unless payment.updated_at < 2.seconds.ago(Time.now)
        end
    end
end