class ArticleMailer < ApplicationMailer
	
	helper ApplicationHelper
	default :from => "Matthew Bennett <matthew@thespainreport.es>"
	
	def send_article_full new_mail, user
		@article = new_mail
		@user = user
		@articletweets = @article.tweets.order('created_at ASC')
		@articleupdates = @article.updates.published.order('created_at ASC')
		mail(:to => "<#{@user.email}>", :subject => email_subject)
	end
	
	def email_subject
		if @article.alertmessage.present?
			"#{@article.alertmessage}"
		else
			"#{@article.type.name}: #{@article.headline}"
		end
		
	end
	
end