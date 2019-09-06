class PaymentMailer < ApplicationMailer
    helper ApplicationHelper
	default	:from => "Matthew Bennett <matthew@thespainreport.es>"
    
    def payment_success new_mail
		@payment = new_mail
		
		headers 'X-SES-CONFIGURATION-SET' => "Emails"
		mail(:to => "matthew@thespainreport.com", :subject => "Thank you for your contribution")
	end
end
