class PaymentMailer < ApplicationMailer
    helper ApplicationHelper
	default	:from => "Matthew Bennett <matthew@thespainreport.es>"
    
    def payment_success(account_id, account_email, language, amount)
        @account = account_id
        @user = account_email
        @language = language
        @amount = amount
        
        @subject = "Funds received 2. Thank you for your support…!"
        
        headers 'X-SES-CONFIGURATION-SET' => "Emails"
        mail(to: @user, subject: @subject)
    end
    
    def payment_admin_message(admin_subject, admin_message)
        @subject = admin_subject
        @message = admin_message
        
        headers 'X-SES-CONFIGURATION-SET' => "Emails"
        mail(to: "matthew@thespainreport.es", subject: @subject)
    end
end
