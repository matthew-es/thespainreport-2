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
            subject_fix = "You have fixed your payment. You have guaranteed independent journalism"
            
            message_first = "Welcome aboard! Your first contribution succeeded..!"
            message_repeat = "Your monthly contribution succeeded...!"
            message_upgrade = "You have increased your contribution successfully..!"
            message_fix = "You have fixed the problem with your contribution successfully..!"
            
            type_first = "First contribution"
            type_repeat = "Monthly contribution"
            type_upgrade = "Increased contribution"
            type_fix = "Problem with contribution fixed"
        when 2
            subject_first = "Se ha recibido su primera contribución. ¡Ha garantizado el periodismo independiente!"
            subject_repeat = "Se ha recibido su contribución mensual. Ha garantizado el periodismo independiente"
            subject_upgrade = "Ha aumentado su contribución. Ha garantizado el periodismo independiente"
            subject_fix = "Ha arreglado el problema con el pago. Ha garantizado el periodismo independiente"
            
            message_first = "¡Bienvenido a bordo! ¡Su primera contribución se ha recibido con éxito..!"
            message_repeat = "¡Su contribución mensual se ha recibido con éxito...!"
            message_upgrade = "¡Ha aumentado su contribución mensual con éxito..!"
            message_fix = "¡Ha solucionado el problema con su contribución con éxito..!"
            
            type_first = "Primera contribución"
            type_repeat = "Contribución mensual"
            type_upgrade = "Contribución aumentada"
            type_fix = "Problema con la contribución solucionado"
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
        when "fix"
            subject = subject_fix
            @type = type_fix
            @message = message_fix
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
