class TweetMailer < ApplicationMailer
    include ActionView::Helpers::TextHelper
    helper ApplicationHelper
	default :from => "Matthew Bennett <matthew@thespainreport.es>"
	
	def send_tweet tweet, user
		@tweet = tweet
		@user = user
		@language = @tweet.article.language_id
		
		mail(:to => "<#{@user.email}>", :subject => subject)
	end
	
	def subject
		if @tweet.article
			@tweet.article.headline
		else
			@tweet.message.mb_chars.limit(70).to_s
		end
	end
    
end