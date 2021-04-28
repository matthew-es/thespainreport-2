class PaymentMailer < ApplicationMailer
    helper ApplicationHelper
	default	:from => "Matthew Bennett <matthew@thespainreport.es>"
    
    
    def payment_success(payment)
        email = payment.account.user.email
        @language = payment.account.user.sitelanguage
        
        @amount = payment.total_amount
        @date = payment.created_at
        @reference = payment.external_payment_id
        
        case @language when 1
            subject_first = "Your first contribution has been received. You have guaranteed independent journalism!"
            subject_repeat = "Your monthly contribution has been received. You have guaranteed independent journalism"
            subject_upgrade = "You have increased your contribution. You have guaranteed independent journalism"
            subject_reactivate = "You have reactivated your contribution! You have guaranteed independent journalism"
            
            message_first = "Welcome aboard! Your first contribution succeeded..!"
            message_repeat = "Your monthly contribution succeeded...!"
            message_upgrade = "You have increased your contribution successfully..!"
            message_reactivate = "You have reactivated your contribution successfully..!"
                
            type_first = "First contribution"
            type_repeat = "Monthly contribution"
            type_upgrade = "Increased contribution"
            type_reactivate = "Reactivated contribution"
        when 2
            subject_first = "Se ha recibido su primera contribución. ¡Ha garantizado el periodismo independiente!"
            subject_repeat = "Se ha recibido su contribución mensual. Ha garantizado el periodismo independiente"
            subject_upgrade = "Ha aumentado su contribución. Ha garantizado el periodismo independiente"
            subject_reactivate = "¡Ha reactivado su contribución! Ha garantizado el periodismo independiente"
            
            message_first = "¡Bienvenido a bordo! ¡Su primera contribución se ha recibido con éxito..!"
            message_repeat = "¡Su contribución mensual se ha recibido con éxito...!"
            message_upgrade = "¡Ha aumentado su contribución mensual con éxito..!"
            message_reactivate = "¡Ha reactivado su contribución con éxito..!"
            
            type_first = "Primera contribución"
            type_repeat = "Contribución mensual"
            type_upgrade = "Contribución aumentada"
            type_reactivate = "Contribución reactivada"
        end
        
        case payment.payment_type when "first"
            subject = subject_first
            @type = type_first
            @message = message_first
        when "repeat"
            subject = subject_repeat
            @type = type_repeat
            @message = message_repeat
        when "increase"
            subject = subject_upgrade
            @type = type_upgrade
            @message = message_upgrade
        when "reactivate"
            subject = subject_reactivate
            @type = type_reactivate
            @message = message_reactivate
        end
        emoji = ("\u2705").force_encoding('utf-8')
        
        headers 'X-SES-CONFIGURATION-SET' => "Emails"
        mail(to: email, subject: emoji + " " + subject)
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
    
    def payment_refunded(payment)
        email = payment.account.user.email
        @language = payment.account.user.sitelanguage
        
        @amount = payment.total_amount
        @date = payment.created_at
        @reference = payment.external_payment_id
        
        case @language when 1 
            subject = ("\u274C").force_encoding('utf-8') + "Payment refunded successfully"
        when 2
            subject = ("\u274C").force_encoding('utf-8') + "Devolución del pago realizado con éxito"
        end
        
        headers 'X-SES-CONFIGURATION-SET' => "Emails"
        mail(to: email, subject: subject)
    end
    
    def subscription_reactivated(subscription)
        email = subscription.account.user.email
        @language = subscription.account.user.sitelanguage
        
        emoji = ("\u2705").force_encoding('utf-8')
        case @language when 1 
            subject = emoji + "Well done, you have reactivated your subscription to The Spain Report"
        when 2
            subject = emoji + "Enhorabuena, ha reactivado su suscripción a The Spain Report"
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
