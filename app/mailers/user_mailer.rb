class UserMailer < ApplicationMailer
    
    default	:from => "Matthew Bennett <matthew@thespainreport.es>"
    
    def password_link(user)
        @user = user
        
        headers 'X-SES-CONFIGURATION-SET' => "Emails"
        mail(to: @user.email, subject: "Password reset: click this link to choose a new password")
    end
    
    def password_link_es(user)
        @user = user
        
        headers 'X-SES-CONFIGURATION-SET' => "Emails"
        mail(to: @user.email, subject: "Clave nueva: haga clic en este enlace para elegir una clave nueva")
    end

end