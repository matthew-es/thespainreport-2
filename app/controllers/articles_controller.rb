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
		@mains = Article.notupdate.order('created_at DESC')
		@frames = Frame.all.order(:emotional_quest_action)
	end
	
	def index
		if current_user.nil? 
			redirect_to root_url
		elsif current_user.role == 1
			@articles = Article.notupdate.nottranslation.notstory.order('created_at DESC')
			@stories = Article.notupdate.nottranslation.story.order('created_at DESC')
			@toplevelstories = Article.notupdate.nottranslation.story.toplevelstory.order('created_at DESC')
		else
			redirect_to root_url
		end
	end

	# GET /articles/1
	# GET /articles/1.json
	def show
		if ["Published", "Updated"].include?@article.status.name
			Visit.create(
				referer: request.headers["HTTP_REFERER"],
				article_id: @article.id,
				frame_id: @article.frame_id,
				plan_ids: ''
				)
				
			@articletweets = @article.tweets.order('created_at ASC')
			@articleupdates = @article.updates.published.order('created_at ASC')
			
			if current_user.nil?
				if @article.frame.blank?
					@frame = Frame.find_by(link_slug: "guarantee")
				else
					@frame = Frame.find_by(id: @article.frame)
				end
				@frame_article = (@frame.language_id == @article.language_id)
				@frametranslation = @frame.translations.where(language_id: @article.language_id).first
				@frameoriginal = @frame.original
			else
				if current_user.frame.blank?
					@frame = Frame.find_by(id: @article.frame)
				else
					@frame = current_user.frame
				end
				@frame_article = (@frame.language_id == @article.language_id)
				@frametranslation = @frame.translations.where(language_id: @article.language_id).first
				@frameoriginal = @frame.original
			end
			
			unless current_user.nil? || !current_user.account.stripe_payment_method.present?
			 @existing_pm = Stripe::PaymentMethod.retrieve(current_user.account.stripe_payment_method)
			 @existing_pm_brand = @existing_pm.card.brand
			 @existing_pm_last4 = @existing_pm.card.last4
			 @existing_pm_month = @existing_pm.card.exp_month
			 @existing_pm_year = @existing_pm.card.exp_year
			end
		
		elsif current_user.nil?
			redirect_to root_url
		elsif current_user.role == 1
			
		else
			redirect_to root_url
		end
	end

	# GET /articles/new
	def new
		if current_user.nil? 
			redirect_to root_url
		elsif current_user.role == 1
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
		elsif current_user.role == 1
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
	
	def email_article
		if params[:article][:email_to] == 'none'
					
		elsif params[:article][:email_to] == 'alert'
			if ["Notes"].include?@article.type.name
				User.emails_notes.emails_english.find_each(batch_size: 50) do |user|
					ArticleMailer.send_article_full(@article, user).deliver_now
				end
			elsif ["Apuntes"].include?@article.type.name
				User.emails_notes.emails_spanish.find_each(batch_size: 50) do |user|
					ArticleMailer.send_article_full(@article, user).deliver_now
				end
			elsif ["Update"].include?@article.type.name
				User.emails_all.emails_english.find_each(batch_size: 50) do |user|
					ArticleMailer.send_article_full(@article, user).deliver_now
				end
			elsif ["Actualización"].include?@article.type.name
				User.emails_all.emails_spanish.find_each(batch_size: 50) do |user|
					ArticleMailer.send_article_full(@article, user).deliver_now
				end
			elsif ["Patrons only"].include?@article.type.name
				User.patrons.emails_full.emails_english.find_each(batch_size: 50) do |user|
					ArticleMailer.send_article_full(@article, user).deliver_now
				end
			elsif ["Sólo patronos"].include?@article.type.name
				User.patrons.emails_full.emails_spanish.find_each(batch_size: 50) do |user|
					ArticleMailer.send_article_full(@article, user).deliver_now
				end
			elsif !["Notes", "Apuntes","Update", "Actualización", "Patrons only", "Sólo patronos"].include?@article.type.name
				if @article.language_id == 1
					User.emails_full.emails_english.find_each(batch_size: 50) do |user|
						ArticleMailer.send_article_full(@article, user).deliver_now
					end
				elsif @article.language_id == 2
					User.emails_full.emails_spanish.find_each(batch_size: 50) do |user|
						ArticleMailer.send_article_full(@article, user).deliver_now
					end
				end
			else
			end
		else
		end
	end

	
	# POST /articles
	# POST /articles.json
	def create
		@article = Article.new(article_params)

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
			params.require(:article).permit(:alertmessage, :audio_file, :audio_intro, :body, :created_at, :frame_id, :extras_audio_file, :extras_audio_intro, :extras_audio_teaser, :extras_notes, :extras_notes_teaser, :extras_transcription_file, :extras_transcription_intro, :extras_transcription_teaser, :headline, :image, :is_breaking, :language_id, :lede, :main_id, :original_id, :status_id, :story_id, :topstory, :type_id, :video)
		end
end