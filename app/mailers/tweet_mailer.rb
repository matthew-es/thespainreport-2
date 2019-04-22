class TweetMailer < ApplicationMailer
    include ActionView::Helpers::TextHelper
    helper ApplicationHelper
	default :from => "Matthew Bennett <matthew@thespainreport.es>"
	
	def send_tweet tweet, user
		@tweet = tweet
		@user = user
		mail(:to => "<#{@user.email}>", :subject => truncate(@tweet.message, length: 70))
	end
    
end