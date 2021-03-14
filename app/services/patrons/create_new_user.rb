module Patrons
    class CreateNewUser
        def self.process(params)

        language_from_server = params[:language_for_server]
        email_from_server = params[:email_for_server]
        article_from_server = params[:article_for_server]
        frame = Frame.find_by(id: params[:frame_for_server])
		
        autopassword = 'L e @ 4' + SecureRandom.hex(32)
		generate_token = SecureRandom.urlsafe_base64.to_s
		
        new_patron = User.create!(
            email: email_from_server,
            confirm_token: generate_token,
            password: autopassword,
            password_confirmation: autopassword,
            password_reset_sent_at: Time.zone.now,
            status: 3,
            level_amount: 0,
            can_read: true,
            can_read_date: Time.zone.now + 45.days,
            sitelanguage: language_from_server,
            emails: 1,
            emaillanguage: language_from_server,
            email_confirmed: false,
            frame_id: frame.id,
            article_from_server: article_from_server
            )

        admin_subject = "New reader: " + new_patron.email
        admin_message = (
        	"New reader: " + new_patron.email + 
        	"<br />Article: " + new_patron.article_from_server + 
        	"<br />Frame: " + new_patron.frame.emotional_quest_action
			).html_safe
			
		UserMailer.welcome_reader(new_patron).deliver_now
		UserMailer.admin_alert(admin_subject, admin_message).deliver_now
        
        new_patron
        end
    end
end