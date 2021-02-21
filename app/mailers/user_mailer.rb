class UserMailer < ApplicationMailer
    
    default	:from => "Matthew Bennett <matthew@thespainreport.es>"
    
    def password_link(user, subject)
        @user = user
        @subject = subject 
        
        headers 'X-SES-CONFIGURATION-SET' => "Emails"
        mail(to: @user.email, subject: @subject)
    end
    
    def password_changed(user, subject)
        @user = user
        @subject = subject
        
        headers 'X-SES-CONFIGURATION-SET' => "Emails"
        mail(to: @user.email, subject: @subject)
    end
    
    def welcome_reader(user)
        @user = user
        emoji = ("\u2705").force_encoding('utf-8')
        
        case @user.sitelanguage when 1
            @latestarticles = Article.published.english.lastten
            subject = emoji + " Welcome: click this link to confirm your email"
        when 2
            @latestarticles = Article.published.spanish.lastten
            subject = emoji + " Bienvenido: haga clic en este enlace para confirmar su correo"
        end
        
        headers 'X-SES-CONFIGURATION-SET' => "Emails"
        mail(to: @user.email, subject: subject)
    end
    
    def user_alert(user, user_subject, user_message)
        @user = user
        @subject = user_subject
        @message = user_message
        
        headers 'X-SES-CONFIGURATION-SET' => "Emails"
        mail(to: @user, subject: @subject)
    end
    
    def admin_alert(admin_subject, admin_message)
        @subject = admin_subject
        @message = admin_message
        
        headers 'X-SES-CONFIGURATION-SET' => "Emails"
        mail(to: "matthew@thespainreport.es", subject: @subject)
    end
end