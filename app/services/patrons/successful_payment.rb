module Patrons
    class SuccessfulPayment
        def self.process(payment, payment_method)
            payment.update(status: "paid", payment_method: payment_method)
            
            if payment.id == payment.account.payments.last.id
            	payment.account.update(stripe_payment_method: payment_method)
            end
            
            payment.subscription.update(
            	is_active: true,
            	next_payment_date: DateTime.now + 1.month,
				reactivate_token: SecureRandom.urlsafe_base64.to_s
				)
			
			payment.subscription.users.each do |u|
				u.update(
					status: 2,
					can_read_date: payment.subscription.next_payment_date
					)
			end
			
			Patrons::CreateInvoice.process(payment) unless Invoice.where(payment_id: payment.id, invoice_operation: "payment").count > 0
			PaymentMailer.payment_success(payment).deliver_now unless payment.updated_at < 1.seconds.ago(Time.now)
        end
    end
end