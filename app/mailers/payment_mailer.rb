class PaymentMailer < ApplicationMailer
    helper ApplicationHelper
	default	:from => "Matthew Bennett <matthew@thespainreport.es>"
    
    
    def phrases
        case @language when 1
            @subject_first = "Your first contribution has been received. You have guaranteed independent journalism!"
            @subject_repeat = "Your monthly contribution has been received. You have guaranteed independent journalism"
            @subject_upgrade = "You have increased your contribution. You have guaranteed independent journalism"
            @subject_reactivate = "You have reactivated your contribution! You have guaranteed independent journalism"
            @subject_problem = "⚠️ " + "Problem with your payment: click this link to fix it"
            @subject_reactivated = ("\u2705").force_encoding('utf-8') + "Well done, you have reactivated your subscription to The Spain Report"
            @subject_refund = ("\u274C").force_encoding('utf-8') + "Payment refunded successfully"
            
            @message_first = "Welcome aboard! Your first contribution succeeded..!"
            @message_repeat = "Your monthly contribution succeeded...!"
            @message_upgrade = "You have increased your contribution successfully..!"
            @message_reactivate = "You have reactivated your contribution successfully..!"
                
            @type_first = "First contribution"
            @type_repeat = "Monthly contribution"
            @type_upgrade = "Increased contribution"
            @type_reactivate = "Reactivated contribution"
            
            @frequency_month = "Monthly"
            @frequency_year = "Yearly"
            @frequency_one_time = "One-time payment"
        when 2
            @subject_first = "Se ha recibido su primera contribución. ¡Ha garantizado el periodismo independiente!"
            @subject_repeat = "Se ha recibido su contribución mensual. Ha garantizado el periodismo independiente"
            @subject_upgrade = "Ha aumentado su contribución. Ha garantizado el periodismo independiente"
            @subject_reactivate = "¡Ha reactivado su contribución! Ha garantizado el periodismo independiente"
            @subject_problem = "⚠️ " + "Problema con su pago: haga clic en este enlace para solucionarlo"
            @subject_reactivated = ("\u2705").force_encoding('utf-8') + "Enhorabuena, ha reactivado su suscripción a The Spain Report"
            @subject_refund = ("\u274C").force_encoding('utf-8') + "Devolución del pago realizado con éxito"
            
            @message_first = "¡Bienvenido a bordo! ¡Su primera contribución se ha recibido con éxito..!"
            @message_repeat = "¡Su contribución mensual se ha recibido con éxito...!"
            @message_upgrade = "¡Ha aumentado su contribución mensual con éxito..!"
            @message_reactivate = "¡Ha reactivado su contribución con éxito..!"
            
            @type_first = "Primera contribución"
            @type_repeat = "Contribución mensual"
            @type_upgrade = "Contribución aumentada"
            @type_reactivate = "Contribución reactivada"
            
            @frequency_month = "Mensual"
            @frequency_year = "Anual"
            @frequency_one_time = "Pago único"
        end
    end
    
    def details(payment)
        @email = payment.account.user.email
        @language = payment.account.user.sitelanguage
        
        @amount = payment.total_amount
        @date = payment.created_at
        @reference = payment.external_payment_id
    end
    
    def frequency(payment)
        phrases
        
        case payment.payment_period when "month"
            @frequency = @frequency_month
        when "year"
            @frequency = @frequency_year
        when "one_time"
            @frequency = @frequency_one_time
        end
    end
    
    def type(payment)
        phrases
        
        case payment.payment_type when "first"
            @subject = @subject_first
            @type = @type_first
            @message = @message_first
        when "repeat"
            @subject = @subject_repeat
            @type = @type_repeat
            @message = @message_repeat
        when "increase"
            @subject = @subject_upgrade
            @type = @type_upgrade
            @message = @message_upgrade
        when "reactivate"
            @subject = @subject_reactivate
            @type = @type_reactivate
            @message = @message_reactivate
        end
    end
    
    
    
    
    def payment_success(payment)
        phrases
        details(payment)
        frequency(payment)
        type(payment)
        
        emoji = ("\u2705").force_encoding('utf-8')
        headers 'X-SES-CONFIGURATION-SET' => "Emails"
        mail(to: @email, subject: emoji + " " + @subject)
    end
   
    def payment_problem(payment)
        phrases
        details(payment)
        frequency(payment)
        type(payment)
        
        headers 'X-SES-CONFIGURATION-SET' => "Emails"
        mail(to: @email, subject: @subject_problem)
    end
    
    def payment_refunded(payment)
        phrases
        details(payment)
        
        headers 'X-SES-CONFIGURATION-SET' => "Emails"
        mail(to: @email, subject: @subject_refund)
    end
    
    def subscription_reactivated(subscription)
        email = subscription.account.user.email
        @language = subscription.account.user.sitelanguage
        
        phrases
        
        headers 'X-SES-CONFIGURATION-SET' => "Emails"
        mail(to: email, subject: @subject_reactivated)
    end
    
    def payment_admin_message(admin_subject, admin_message)
        @subject = admin_subject
        @message = admin_message
        
        headers 'X-SES-CONFIGURATION-SET' => "Emails"
        mail(to: "matthew@thespainreport.es", subject: @subject)
    end
end
