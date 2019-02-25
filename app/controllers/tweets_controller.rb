class TweetsController < ApplicationController
	before_action :set_tweet, only: [:show, :edit, :update, :destroy]

	def tweetelements
		@previoustweets = Tweet.all.order("created_at DESC")
		@articles = Article.all.order("created_at DESC")
	end
	
	def index
		if current_user.nil? 
			redirect_to root_url
		elsif !current_user.nil?
			@tweets = Tweet.all.order("created_at DESC")
		else
			redirect_to root_url
		end
	end

	# GET /tweets/1
	# GET /tweets/1.json
	def show
		if current_user.nil? 
			redirect_to root_url
		elsif !current_user.nil?
			
		else
			redirect_to root_url
		end
	end

	# GET /tweets/new
	def new
		if current_user.nil? 
			redirect_to root_url
		elsif !current_user.nil?
			@tweet = Tweet.new
			tweetelements
		else
			redirect_to root_url
		end
	end

	# GET /tweets/1/edit
	def edit
		if current_user.nil? 
			redirect_to root_url
		elsif !current_user.nil?
			tweetelements
		else
			redirect_to root_url
		end
	end

	# POST /tweets
	# POST /tweets.json
	def create
		@tweet = Tweet.new(tweet_params)
		
		if @tweet.image
			# Grab the image from the form field, write it to temporary folder
			tf = "#{Rails.root}/tmp/#{params[:tweet][:image].original_filename}"
			File.open(tf, 'wb') do |f|
				f.write params[:tweet][:image].read
			end
			# Put the image on S3
			s3 = Aws::S3::Resource.new()
			bucket = 'image.thespainreport.es'
			name = File.basename(tf)
			obj = s3.bucket(bucket).object(name)
			obj.upload_file(tf)
			# Create a new upload entry in Rails database, for use elsewhere
			@upload = Upload.new(
					data: obj.public_url
				)
			@upload.save
			# Update the tweet with the image reference
			@tweet.update(
				image: File.basename(tf)
			)
		else
		end
		
		# Now send the tweet
		if @tweet.previous.present?
			if @tweet.image
				@send = $client.update_with_media(@tweet.message, File.new(tf), in_reply_to_status_id: @tweet.previous.twitter_tweet_id)
			else
				@send = $client.update(@tweet.message, in_reply_to_status_id: @tweet.previous.twitter_tweet_id)
			end
		else
			if @tweet.image
				@send = $client.update_with_media(@tweet.message, File.new(tf))
			else
				@send = $client.update(@tweet.message)
			end
		end
		
		@tweet.update(
			twitter_tweet_id: @send.id
			)
		
		respond_to do |format|
			if @tweet.save
				format.html { redirect_to @tweet, notice: 'Tweet was successfully created.' }
				format.json { render :show, status: :created, location: @tweet }
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
				format.html { redirect_to @tweet, notice: 'Tweet was successfully updated.' }
				format.json { render :show, status: :ok, location: @tweet }
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
			params.require(:tweet).permit(:article_id, :image, :message, :previous_id, :twitter_tweet_id)
		end
end
