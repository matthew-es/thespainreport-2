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
        @latestpodcasts = Article.published.english.podcast.lastfive
        @latestfree = Article.published.english.notpodcast.notpatrons.nottruth.lastfive
        @latesttruth = Article.published.english.truth.lastfive
        @latestpatrons = Article.published.english.patrons.lastfive
        
        headers 'X-SES-CONFIGURATION-SET' => "Emails"
        mail(to: @user.email, subject: "Welcome: click this link to confirm your email")
    end
    
    def welcome_reader_es(user)
        @user = user
        @latestpodcasts = Article.published.spanish.podcast.lastfive
        @latestfree = Article.published.spanish.notpodcast.notpatrons.nottruth.lastfive
        @latesttruth = Article.published.spanish.truth.lastfive
        @latestpatrons = Article.published.spanish.patrons.lastfive
        
        headers 'X-SES-CONFIGURATION-SET' => "Emails"
        mail(to: @user.email, subject: "Bienvenido: haga clic en este enlace para confirmar su correo")
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