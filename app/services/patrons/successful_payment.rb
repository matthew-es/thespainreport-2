module Patrons
    class SuccessfulPayment
        def self.process(payment, payment_method)
            puts "SUCCESSFUL PAYMENT SERVICE -- INSIDE"
            
            payment.update(status: "paid", payment_method: payment_method)
            
            puts "SUCCESSFUL PAYMENT SERVICE -- PAYMENT UPDATED"
            
            if payment.id == payment.account.payments.last.id
            	payment.account.update(stripe_payment_method: payment_method, total_support: payment.subscription.plan_amount)
            end

            puts "SUCCESSFUL PAYMENT SERVICE -- TIME TO CREATE INVOICE"

			Patrons::CreateInvoice.process(payment) unless Invoice.where(payment_id: payment.id, account_id: payment.account.id, invoice_operation: "payment").count > 0
			Patrons::SubscriptionUpdateUsers.process(payment.subscription, payment.base_amount)
			PaymentMailer.payment_success(payment).deliver_now unless payment.updated_at < 1.seconds.ago(Time.now)
			
			admin_subject = ("\u2705").force_encoding('utf-8') + " " + payment.payment_type.upcase + " " + (ActiveSupport::NumberHelper.number_to_currency((payment.total_amount/100.to_f), unit: "€")).to_s + " from " + payment.account.user.email
			admin_message = ""
			PaymentMailer.payment_admin_message(admin_subject, admin_message).deliver_now unless payment.updated_at < 1.seconds.ago(Time.now)
        end
    end
end