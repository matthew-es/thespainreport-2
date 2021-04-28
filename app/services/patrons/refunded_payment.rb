module Patrons
	class RefundedPayment
		def self.process(payment)
			
			payment.update(status: "refunded")
			payment.subscription.update(is_active: false, next_payment_date: DateTime.now)
			payment.subscription.users.each do |u|
			   u.update(
			   	can_read_date: DateTime.now
			   	)
			end
			
			Patrons::CreateInvoiceRefund.process(payment) unless Invoice.where(payment_id: payment.id, account_id: payment.account.id, invoice_operation: "refund").count > 0
			PaymentMailer.payment_refunded(payment).deliver_now unless payment.updated_at < 1.seconds.ago(Time.now)
			
			admin_subject = ("\u274C").force_encoding('utf-8') + " REFUNDED: " + payment.payment_type.upcase + " " + (ActiveSupport::NumberHelper.number_to_currency((payment.total_amount/100.to_f), unit: "€")).to_s + " from " + payment.account.user.email
			admin_message = ""
			PaymentMailer.payment_admin_message(admin_subject, admin_message).deliver_now unless payment.updated_at < 1.seconds.ago(Time.now)
		end
	end
end