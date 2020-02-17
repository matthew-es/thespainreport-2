class ArticleMailer < ApplicationMailer
	
	helper ApplicationHelper
	default	:from => "Matthew Bennett <matthew@thespainreport.es>"
	
	def send_article_full new_mail, user
		@article = new_mail
		@articletweets = @article.tweets.order('created_at ASC')
		@articleupdates = @article.updates.published.order('created_at ASC')
		@language = @article.language_id
		if @language == 1
			@value = "value/"
		elsif @language == 2
			@value = "valor/"
		else end
		@subscribe = root_url + @value + @article.frame.link_slug
		
		@user = user
		@level = @user.level_amount
			
		headers 'X-SES-CONFIGURATION-SET' => "Emails"
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