class ArticleMailer < ApplicationMailer
	
	helper ApplicationHelper
	default	:from => "Matthew Bennett <matthew@thespainreport.es>"
	
	def send_article_full new_mail, user
		@article = new_mail
		@articletweets = @article.tweets.order('created_at ASC')
		@articlepieces = @article.pieces.published.order('created_at ASC')
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
		@can_read_date = @user.can_read_date
		@level = @user.level_amount
		@account_status = @user.account.account_status unless @user.account.nil?		
		
		@admin = @status == 1
		@super_patron = @status == 2 && (@level > 25)
		@patron_reader_25 = @status == 2 && (@level == 25)
		@patron_reader_10 = @status == 2 && @level.between?(10, 24)
		@patron_reader_5 = @status == 2 && @level.between?(5, 9)
		@patron_reader_1 = @status == 2 && @level.between?(1, 4)
		@patron_reader_0 = @status == 2 && (@level == 0)
		@patron = @patron_reader_0 || @patron_reader_1 || @patron_reader_5 || @patron_reader_10 || @patron_reader_25
		@reader_trial = @status == 3 && @can_read_date > Time.now
		@reader_trial_over = @status == 3 && @can_read_date < Time.now
		
		@can_read_level_1 = @admin || @reader_trial|| @super_patron || @patron_reader_25 || @patron_reader_10 || @patron_reader_5  || @patron_reader_1
		
		headers 'X-SES-CONFIGURATION-SET' => "Emails"
		mail(:to => "<#{@user.email}>", :subject => email_subject)
	end
	
	def email_subject
		case @article.type.name
			when "Patrons only", "Sólo mecenas" then @emoji = "🔓 📝"
			when "Video", "Vídeo" then @emoji = "🎥"
			when "Podcast" then @emoji = "🎧"
			when "Photos", "Fotos" then @emoji = "📷"
			when "Truth & Journalism", "Verdad y Periodismo" then @emoji = "🔎 📝"
			else @emoji = "📝"
		end
		
		"#{@emoji} #{@article.type.name}: #{@article.headline}"
	end
	
end