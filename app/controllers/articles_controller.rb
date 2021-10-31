class ArticlesController < ApplicationController
	
	before_action :set_article, only: [:show, :edit, :update, :destroy]
	
	# GET /articles
	# GET /articles.json
	def article_elements
		@types = Type.all.order(:name)
		@statuses = Status.all.order(:name)
		@languages = Language.all.order(:name)
		@stories = Article.story.order('headline ASC')
		if @article.language_id == 1
			@translationof = Article.spanish.order('created_at DESC')
		elsif @article.language_id == 2
			@translationof = Article.english.order('created_at DESC')
		else
		end
		@mains = Article.is_main.order('created_at DESC')
		@frames = Frame.all.order(:emotional_quest_action)
		@uploads = Upload.all.order('created_at DESC').limit(100)
		@audios_aac = Upload.audios_aac.order('created_at DESC').limit(100)
		@audios_mp3 = Upload.audios_mp3.order('created_at DESC').limit(100)
	end
	
	def index
		if current_user.nil? 
			redirect_to root_url
		elsif current_user.status == 1
			@free = Article.nottruth.notpatrons.notaudioreport.notaudiointerview.nottranslation.notvideo.notphoto.notstory.order('created_at DESC').limit(20)
		
			
			@daily = Article.daily.nottranslation.order('created_at DESC').limit(10)
			@depth = Article.depth.nottranslation.order('created_at DESC').limit(10)
			@blog = Article.blog.nottranslation.order('created_at DESC').limit(10)
			
			@all = Article.all.nottranslation.order('created_at DESC')
			
			@frame_en = Frame.find_by(link_slug: "guarantee")
			@frame_es = Frame.find_by(link_slug: "garantizar")
			Article.all.each do |a|
				if a.frame_id.blank?
					case a.language_id
						when 1
							set = @frame_en
						when 2
							set = @frame_es
					end
					a.update(frame_id: set.id)
				else end
			end
		else
			redirect_to root_url
		end
	end
	
	def live
		@article = Article.english.live.published.last
		frame = Frame.find_by(link_slug: "guarantee")
		set_language_frame(@article.language_id, frame.id)
		set_status(current_user) unless current_user.nil?
		
		render 'articles/show'
	end
	
	def directo
		@article = Article.spanish.live.published.last
		frame = Frame.find_by(link_slug: "garantizar")
		set_language_frame(@article.language_id, frame.id)
		set_status(current_user) unless current_user.nil?
		
		render 'articles/show'
	end

	# GET /articles/1
	# GET /articles/1.json
	def show
		if @article.frame.present?
			frame = @article.frame.id
		elsif @article.language == 1
			frame = Frame.find_by(link_slug: "guarantee")
		elsif @article.language == 2
			frame = Frame.find_by(link_slug: "garantizar")
		else
		end
		set_language_frame(@article.language_id, frame)
		set_status(current_user) unless current_user.nil?
		placeholders
		
		if ["Published", "Updated"].include?@article.status.name
			
			@article_id = @article.id
			@frame_id = @frame.id
			@articletweets = @article.tweets.order('created_at ASC')
			@articlepieces = @article.pieces.published.order('created_at ASC')
			
		elsif current_user.nil?
			redirect_to root_url
		elsif current_user.status == 1
			
		else
			redirect_to root_url
		end
	end

	# GET /articles/new
	def new
		if current_user.nil? 
			redirect_to root_url
		elsif current_user.status == 1
			@article = Article.new
			article_elements
			@translationof = Article.spanish.order('created_at DESC')
		else
			redirect_to root_url
		end
	end

	# GET /articles/1/edit
	def edit
		if current_user.nil? 
			redirect_to root_url
		elsif current_user.status == 1
			article_elements
			
		else
			redirect_to root_url
		end
		
	end
	
	def tweet_article
		if params[:tweet] == '1'
			$client.update(tweet)
		else
		end
	end
	
	def tweet
		if @article.alertmessage?
      		@article.alertmessage + ' ' + article_url(@article)
	   	else
	      	@article.type.name + ': ' + @article.headline + ' ' + article_url(@article)
	   	end
	end
	
	def touser
		@article = Article.find(params[:article_id])
		ArticleMailer.send_article_full(@article, current_user).deliver_now
		redirect_back(fallback_location: root_path)
	end
	
	def add_article_image
		article_image = params[:article][:image_main]
		article_image_high = params[:article][:image_high]
		
		# Upload main version of image, update tweet with id
		if article_image
			upload = article_image
			version = 1
			main = ""
			@upload_main = Uploads::UploadFile.process(upload, version, main)
			
			# Update the article with the upload_id
			@article.update(upload_id: @upload_main.id)
		else
		end
		
		# Upload high res version of image, do NOT update tweet
		if article_image_high
			upload = article_image_high
			version = 2
			main = @upload_main.id
			upload_high = Uploads::UploadFile.process(upload, version, main)
		else
		end
	end
	
	def add_article_podcast
		article_aac = params[:article][:audio_upload_aac]
		article_mp3 = params[:article][:audio_upload_mp3]
		
		if article_aac && article_mp3
			upload = article_aac
			version = 1
			main = ""
			upload_aac = Uploads::UploadFile.process(upload, version, main)
			
			upload_2 = article_mp3
			version_2 = 2
			main_2 = upload_aac.id
			upload_mp3 = Uploads::UploadFile.process(upload_2, version_2, main_2)

			@article.update(
				audio_aac_id: upload_aac.id,
				audio_mp3_id: upload_mp3.id
				)
		elsif !article_aac && article_mp3
			if @article.audio_aac_id?
				version = 2
				main = @article.audio_aac_id
			else
				version = 1
				main = ""
			end
			
			upload = article_mp3
			upload_mp3 = Uploads::UploadFile.process(upload, version, main)
			@article.update(audio_mp3_id: upload_mp3.id)
		elsif article_aac && !article_mp3
			if @article.audio_mp3_id?
				version = 2
				main = @article.audio_mp3_id
			else
				version = 1
				main = ""
			end
			
			upload = article_aac
			upload_aac = Uploads::UploadFile.process(upload, version, main)
			@article.update(audio_aac_id: upload_aac.id)
		else
		end
	end
	
	def email_article
		if params[:article][:email_to] == 'none'
		
		elsif params[:article][:email_to] == 'test'
			users = [User.find_by(email: "matthew@thespainreport.com"), User.find_by(email: "matbenet77@gmail.com")]
			users.each do |user|
				ArticleMailer.send_article_full(@article, user).deliver_now
			end
		elsif params[:article][:email_to] == 'discord'
			if @article.type.name == "Patrons Column"
				discord_url = URI("https://discord.com/api/webhooks/815276312247795723/72Ib0XzZ1SLjxahBaR7QWE10lM9IdDt5yxncxXtpxe6fILJnTcv9paDuX-hkODMl3nwK")
			elsif @article.type.name = "Columna Mecenas"
				discord_url = URI("https://discord.com/api/webhooks/815290225273995324/nAJkFq869-Q1n16rPWn9W96gshhNHmOuZfA8FJUj7rLgjUX-R5eO6LS-cj3PzTN93NjM")
			else end
			
			discord_message = @article.short_headline.upcase + "\n\n" + @article.body
			Net::HTTP.post_form(discord_url, 'content' => discord_message)
		elsif params[:article][:email_to] == 'alert'
			i = 0
			
			if ["Notice"].include?@article.type.name
				User.emails_notes.emails_english.find_each(batch_size: 50) do |user|
					ArticleMailer.send_article_full(@article, user).deliver_now
					i += 1
				end
			elsif ["Aviso"].include?@article.type.name
				User.emails_notes.emails_spanish.find_each(batch_size: 50) do |user|
					ArticleMailer.send_article_full(@article, user).deliver_now
					i += 1
				end
			elsif ["Update"].include?@article.type.name
				User.emails_all.emails_english.find_each(batch_size: 50) do |user|
					ArticleMailer.send_article_full(@article, user).deliver_now
					i += 1
				end
			elsif ["Actualización"].include?@article.type.name
				User.emails_all.emails_spanish.find_each(batch_size: 50) do |user|
					ArticleMailer.send_article_full(@article, user).deliver_now
					i += 1
				end
			elsif !["Notices", "Avisos", "Update", "Actualización"].include?@article.type.name
				if @article.language_id == 1
					User.emails_full.emails_english.find_each(batch_size: 50) do |user|
						ArticleMailer.send_article_full(@article, user).deliver_now
						i += 1
					end
				elsif @article.language_id == 2
					User.emails_full.emails_spanish.find_each(batch_size: 50) do |user|
						ArticleMailer.send_article_full(@article, user).deliver_now
						i += 1
					end
				end
			else
			end
		
		admin_subject = DateTime.now.strftime("%d/%m %H:%M: ") + i.to_s + " ARTICLES SENT BY EMAIL"
		admin_message = ""
		PaymentMailer.payment_admin_message(admin_subject, admin_message).deliver_now
		
		else
		end
	end

	
	# POST /articles
	# POST /articles.json
	def create
		@article = Article.new(article_params)
		add_article_image
		add_article_podcast
		
		respond_to do |format|
			if @article.save
				format.html { redirect_to edit_article_path(@article), notice: 'Article was successfully created.' }
				format.json { render :edit, status: :created, location: @article }
			else
				format.html { render :new }
				format.json { render json: @article.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT /articles/1
	# PATCH/PUT /articles/1.json
	def update
		params[:article][:story_ids] ||= []
		
		respond_to do |format|
			if @article.update(article_params)
				add_article_image
				add_article_podcast
				
				format.html { redirect_to edit_article_path(@article), notice: 'Article was successfully updated.' }
				format.json { render :edit, status: :ok, location: @article }
				
				if ["Draft", "Editing"].include?(@article.status.name)
					
				elsif ["Published", "Updated"].include?(@article.status.name)
					email_article
					tweet_article
				else
				end
				
			else
				format.html { render :edit }
				format.json { render json: @article.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /articles/1
	# DELETE /articles/1.json
	def destroy
		@article.destroy
		respond_to do |format|
			format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
			format.json { head :no_content }
		end
	end

	private
		# Use callbacks to share common setup or constraints between actions.
		def set_article
			@article = Article.find(params[:id])
		end

		# Never trust parameters from the scary internet, only allow the white list through.
		def article_params
			params.require(:article).permit(:alertmessage, :audio_file_mp3, :audio_file_aac, :audio_intro, :body, :created_at, :frame_id, :extras_audio_file, 
			:audio_file_episode, :audio_episode_notes, :audio_file_duration, :audio_file_mp3_length, :audio_file_mp3_type, :audio_file_aac_length, :audio_file_aac_type, 
			:extras_audio_intro, :extras_audio_title, :extras_audios, :extras_notes_teaser, :extras_video_title, :extras_video_intro, :extras_videos, 
			:short_headline, :headline, :image, :is_breaking, :language_id, :lede, :main_id, :original_id, :status_id, :story_id, :topstory, :type_id, :video,
			:upload_id, :audio_aac_id, :audio_mp3_id, :extra_audio_aac_id, :extra_audio_mp3_id
			)
		end
end