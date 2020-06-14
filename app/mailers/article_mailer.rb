class ArticleMailer < ApplicationMailer
	
	helper ApplicationHelper
	default	:from => "Matthew Bennett <matthew@thespainreport.es>"
	
	def send_article_full new_mail, user
		@article = new_mail
		@articletweets = @article.tweets.order('created_at ASC')
		@articleupdates = @article.updates.published.order('created_at ASC')
		@language = @article.language_id
		@frame = @article.frame
		
		if @language == 1
			@value = "value/"
			@increase_value = "value/"
			@restart_value = "value/" 
		elsif @language == 2
			@value = "valor/"
			@increase_value = "valor/"
			@restart_value = "valor/" 
		else end
		@subscribe = root_url + @value + @frame.link_slug
		@increase = root_url + @increase_value + @frame.link_slug
		@restart = root_url + @restart_value + @frame.link_slug
		
		@user = user
		@status = @user.status
		@level = @user.level_amount
		@can_read = @user.can_read
			
		headers 'X-SES-CONFIGURATION-SET' => "Emails"
		mail(:to => "<#{@user.email}>", :subject => email_subject)
	end
	
	def email_subject
		case @article.type.name
			when "Patrons only", "Sólo mecenas" then @emoji = "🔓"
			when "Podcast" then @emoji = "🎧"
			when "Notes", "Apuntes" then @emoji = "📝"
			when "Truth & Journalism", "Verdad y Periodismo" then @emoji = "🔎"
			else @emoji = "🟢"
		end
		
		"#{@emoji} #{@article.type.name}: #{@article.headline}"
	end
	
end