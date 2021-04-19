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
		@super_patron = @status == 2 && (@level > 2500)
		@patron_25 = @status == 2 && (@level == 2500)
		@patron_10 = @status == 2 && @level.between?(1000, 2499)
		@patron_5 = @status == 2 && @level.between?(500, 999)
		@patron_1 = @status == 2 && @level.between?(100, 499)
		@patron_paused = (@user.account.subscriptions.last.is_active == false) unless @user.account.subscriptions.blank?
		
		@patron = @patron_1 || @patron_5 || @patron_10 || @patron_25 || @patron_paused
		@reader_trial = (@status == 3 && @can_read_date > Time.now)
		@reader_trial_over = @status == 3 && @can_read_date < Time.now
		@reader = @readertrial || @reader_trial_over
		@get_prints = @admin || @super_patron || @patron_25 || @reader_trial
		
		@can_read_level_1 = @admin || @reader_trial|| @super_patron || @patron_25 || @patron_10 || @patron_5  || @patron_1
		@can_read_level_5 = @admin || @reader_trial|| @super_patron || @patron_25 || @patron_10 || @patron_5
		@can_read_level_10 = @admin || @reader_trial|| @super_patron || @patron_25 || @patron_10
		@can_read_level_25 = @admin || @reader_trial|| @super_patron || @patron_25
		@cannot_read_1 = @reader_trial_over || @patron_paused || @patron_1
		@cannot_read_2 = @reader_trial_over || @patron_paused || @patron_1 || @patron_5
		
		@reactivate = reactivate_subscription_payment_url(@user.account.subscriptions.last.reactivate_token) unless @user.account.subscriptions.blank? || @user.account.subscriptions.last.reactivate_token.nil?
		
		headers 'X-SES-CONFIGURATION-SET' => "Emails"
		mail(:to => "<#{@user.email}>", :subject => email_subject)
	end
	
	def email_subject
		case @article.type.name
			when "Patrons Column", "Columna Mecenas" then @emoji = "🔓 📝"
			when "Notes", "Apuntes" then @emoji = "📝"
			when "Video", "Vídeo", "Video Blog", "Vídeo Blog" then @emoji = "🎥"
			when "Podcast" then @emoji = "🎧"
			when "Photos", "Fotos" then @emoji = "📷"
			when "Truth & Journalism", "Verdad y Periodismo" then @emoji = "🔎 📝"
			else @emoji = "📝"
		end
		
		"#{@emoji} #{@article.type.name}: #{@article.headline}"
	end
	
end