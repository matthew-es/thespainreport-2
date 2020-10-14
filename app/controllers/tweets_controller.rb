class TweetsController < ApplicationController

	before_action :set_tweet, only: [:show, :edit, :update, :destroy]

	def tweetelements
		@previoustweets = Tweet.last50
		@articles = Article.all.order("created_at DESC")
		@languages = Language.all.order(:name)
		@types = Type.all.order(:name)
		@stories = Article.story.order('headline ASC')
		@translationof = Article.lastten.order('created_at DESC')
		@uploads = Upload.all.order('created_at DESC').limit(50)
	end
	
	def index
		if current_user.nil? 
			redirect_to root_url
		elsif current_user.status == 1
			@tweets = Tweet.last50
		else
			redirect_to root_url
		end
	end

	# GET /tweets/1
	# GET /tweets/1.json
	def show
		if current_user.nil? 
			redirect_to root_url
		elsif current_user.status == 1
			redirect_to edit_tweet_path(@tweet)
		else
			redirect_to root_url
		end
	end

	# GET /tweets/new
	def new
		if current_user.nil? 
			redirect_to root_url
		elsif current_user.status == 1
			@tweet = Tweet.new
			if params
				@tweet.previous_id = params[:previous_id]
				@tweet.article_id = params[:article_id]
			end
			tweetelements
		else
			redirect_to root_url
		end
	end

	# GET /tweets/1/edit
	def edit
		if current_user.nil? 
			redirect_to root_url
		elsif current_user.status == 1
			tweetelements
		else
			redirect_to root_url
		end
	end
	
	
	def add_tweet_image
		
		# Upload main version of image, update tweet with id
		if params[:tweet][:image]
			upload = params[:tweet][:image]
			version = 1
			main = ""
			@upload_main = Uploads::UploadFile.process(upload, version, main)
			
			# Update the tweet with the upload_id
			@tweet.update(upload_id: @upload_main.id)
		else
		end
		
		# Upload high res version of image, do NOT update tweet
		if params[:tweet][:image_high]
			upload = params[:tweet][:image_high]
			version = 2
			main = @upload_main.id
			upload_high = Uploads::UploadFile.process(upload, version, main)
		else
		end
		
		# Use image as article main image too
		if params[:tweet][:set_article_image] == "1"
			@tweet.article.update(upload_id: @tweet.upload.id)
		else
		end
		
	end
	
	
	def email_tweet
		if params[:tweet][:email_to] == 'none'
		
		elsif params[:tweet][:email_to] == 'test'
			user = User.find_by(email: "matthew@thespainreport.com")
			TweetMailer.send_tweet(@tweet, user).deliver_now
		elsif params[:tweet][:email_to] == 'alert'
			if @tweet.language_id == 1
				User.emailsall.emailsenglish.each do |user|
					TweetMailer.send_tweet(@tweet, user).deliver_now
				end
			elsif @tweet.language_id == 2
				User.emailsall.emailsspanish.each do |user|
					TweetMailer.send_tweet(@tweet, user).deliver_now
				end
			else
			end
		else
		end
	end
	
	def send_tweet
		if params[:tweet][:send_tweet] == 'none'
		
		elsif params[:tweet][:send_tweet] == 'send'
			
			# With a link?
			if params[:tweet][:tweet_this_url] == "1"
				tweetlink = article_url(@tweet.article)
			elsif params[:tweet][:tweet_url]
				tweetlink = params[:tweet][:tweet_url]
			else 
				tweetlink = ""
			end
			
			# Get the image ready if there is one
			if @tweet.upload
				@existing = Uploads::TweetExisting.process(@tweet.upload.data)
			end
		
			# In a thread, with an image?
			if @tweet.previous.present?
				if @tweet.upload
					@send = $client.update_with_media(@tweet.message + ' ' + tweetlink, @existing, in_reply_to_status_id: @tweet.previous.twitter_tweet_id)
				else
					@send = $client.update(@tweet.message + ' ' + tweetlink, in_reply_to_status_id: @tweet.previous.twitter_tweet_id)
				end
			else
				if @tweet.upload
					@send = $client.update_with_media(@tweet.message + ' ' + tweetlink, @existing)
				else
					@send = $client.update(@tweet.message + ' ' + tweetlink)
				end
			end
			
			# Update tweet with actual Twitter status id
			@tweet.update(twitter_tweet_id: @send.id)
			
		else
		end
	end

	# POST /tweets
	# POST /tweets.json
	def create
		@tweet = Tweet.new(tweet_params)
		
		# Create a new article for the first tweet in the thread…
		if params[:tweet][:new_article_headline].present?
			
			case params[:tweet][:language_id]
				when "1" then @frame = Frame.find_by(link_slug: "guarantee")
				when "2" then @frame = Frame.find_by(link_slug: "garantizar")
			end
			
			a = Article.create(
			headline: params[:tweet][:new_article_headline],
			short_headline: params[:tweet][:new_article_short_headline],
			lede: params[:tweet][:new_article_lede],
			body: params[:tweet][:new_article_text],
			status_id: 3,
			language_id: params[:tweet][:language_id],
			type_id: params[:tweet][:type_id],
			original_id: params[:tweet][:original_id],
			frame_id: @frame.id
			)
			
			@tweet.update(
				article_id: a.id
			)
			
		end
		
		# Add the image if there is one
		add_tweet_image
		
		# Grab a quick translation
		if @tweet.article.present?
			tr = Aws::Translate::Client.new()
			
			if @tweet.article.language_id == 1
				reply = tr.translate_text(
				  text: @tweet.message, # required
				  source_language_code: "en", # required
				  target_language_code: "es", # required
				)
			elsif @tweet.article.language_id == 2
				reply = tr.translate_text(
				  text: @tweet.message, # required
				  source_language_code: "es", # required
				  target_language_code: "en", # required
				)
			else
			end
			
			@tweet.update(
				quicktranslation: reply.translated_text
				)
		end 
		
		# Now send the tweet
		send_tweet
		
		respond_to do |format|
			if @tweet.save
				email_tweet
				
				if @tweet.previous_id.present?
					format.html { redirect_to new_tweet_path(previous_id: @tweet, article_id: @tweet.article_id), notice: 'Tweet was successfully created.' }
					format.json { render :show, status: :created, location: @tweet }
				else
					format.html { redirect_to tweets_path, notice: 'Tweet was successfully created.' }
					format.json { render :show, status: :created, location: @tweet }
				end
			else
				format.html { render :new }
				format.json { render json: @tweet.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT /tweets/1
	# PATCH/PUT /tweets/1.json
	def update
		
		respond_to do |format|
			if @tweet.update(tweet_params)
				add_tweet_image
				send_tweet
				email_tweet
				
				format.html { redirect_to edit_tweet_path(@tweet), notice: 'Tweet was successfully updated.' }
				format.json { render :edit, status: :ok, location: @tweet }
			else
				format.html { render :edit }
				format.json { render json: @tweet.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /tweets/1
	# DELETE /tweets/1.json
	def destroy
		@tweet.destroy
		$client.destroy_status(@tweet.twitter_tweet_id)
		
		respond_to do |format|
			format.html { redirect_to tweets_url, notice: 'Tweet was successfully destroyed.' }
			format.json { head :no_content }
		end
	end

	private
		# Use callbacks to share common setup or constraints between actions.
		def set_tweet
			@tweet = Tweet.find(params[:id])
		end

		# Never trust parameters from the scary internet, only allow the white list through.
		def tweet_params
			params.require(:tweet).permit(:article_id, :image, :tweet_url, :message, :previous_id, :quicktranslation, :twitter_tweet_id, :upload_id)
		end
end
