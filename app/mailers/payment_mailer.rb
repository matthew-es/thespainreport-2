class PaymentMailer < ApplicationMailer
    helper ApplicationHelper
	default	:from => "Matthew Bennett <matthew@thespainreport.es>"
    
    
    def payment_success(payment)
        email = payment.account.user.email
        @language = payment.account.user.sitelanguage
        
        @amount = payment.total_amount
        @date = payment.created_at
        @reference = payment.external_payment_id
        
        emoji = ("\u2705").force_encoding('utf-8')
        case @language when 1
            subject = emoji + "Monthly contribution received. You have guaranteed independent journalism"
        when 2
            subject = emoji + "Contribución mensual recibida. Ha garantizado el periodismo independiente"
        end
        
        headers 'X-SES-CONFIGURATION-SET' => "Emails"
        mail(to: email, subject: subject)
    end
    
    
    def payment_problem(payment)
        email = payment.account.user.email
        @language = payment.account.user.sitelanguage
        
        @amount = payment.total_amount
        @date = payment.created_at
        @reference = payment.external_payment_id
        
        case @language when 1 
            subject = "⚠️ " + "Problem with your payment: click this link to fix it"
        when 2
            subject = "⚠️ " + "Problema con su pago: haga clic en este enlace para solucionarlo"
        end
        
        headers 'X-SES-CONFIGURATION-SET' => "Emails"
        mail(to: email, subject: subject)
    end
    
    
    def payment_admin_message(admin_subject, admin_message)
        @subject = admin_subject
        @message = admin_message
        
        headers 'X-SES-CONFIGURATION-SET' => "Emails"
        mail(to: "matthew@thespainreport.es", subject: @subject)
    end
end
