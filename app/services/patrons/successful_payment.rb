module Patrons
    class SuccessfulPayment
        def self.process(payment, payment_method)
            payment.update(status: "paid", payment_method: payment_method)
            
            if payment.id == payment.account.payments.last.id
            	payment.account.update(stripe_payment_method: payment_method, total_support: payment.total_amount)
            end

			Patrons::CreateInvoice.process(payment) unless Invoice.where(payment_id: payment.id, account_id: payment.account.id, invoice_operation: "payment").count > 0
			PaymentMailer.payment_success(payment).deliver_now unless payment.updated_at < 1.seconds.ago(Time.now)
        end
    end
end