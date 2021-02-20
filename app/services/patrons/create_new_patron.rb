module Patrons
    class CreateNewPatron
        def self.process(params, url_path)

        language_from_server = params[:language_for_server]
        email_from_server = params[:email_for_server]
        article_from_server = params[:article_for_server]
        frame = Frame.find_by(id: params[:frame_for_server])
        
        case article_from_server
			when "0"
				case url_path
					when "/" then sign_up_article = "/"
					when "/es" then sign_up_article = "/es"
					when "/newsletter" then sign_up_article = "/newsletter"
					when "/boletin" then sign_up_article = "/boletin"
				end
			else
				article = Article.find_by(id: params[:article_for_server])
				sign_up_article = article.headline
		end
        
        frame_id = frame.id
		frame_quest_action = frame.emotional_quest_action
		frame_quest_role = frame.emotional_quest_role
		
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
            frame_id: frame_id
            )
        
        Bookmark.create!(
			user_id: new_patron.id,
			new_email_reader_article: true,
			article_id: article_from_server.to_i,
			article_headline: sign_up_article,
			frame_id: frame_id,
			frame_emotional_quest_action: frame_quest_action
			)
		
		account = Account.create!(
			user_id: new_patron.id,
			account_status: 4,
			account_status_date: Time.zone.now,
			conversation_status: 1,
			total_support: 0
			)
		
		new_patron.update(
			account_id: account.id,
			account_role: 1
			)

        admin_subject = "New reader: " + new_patron.email
        admin_message = (
        	"New reader: " + new_patron.email + 
        	"<br />Article: " + sign_up_article + 
        	"<br />Frame: " + frame_quest_action
			).html_safe
			
		UserMailer.welcome_reader(new_patron).deliver_now
		UserMailer.admin_alert(admin_subject, admin_message).deliver_now
        
        new_patron
        end
    end
end