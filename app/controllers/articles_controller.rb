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
		@campaigns = Campaign.all.order(:name)
	end
	
	def index
		if current_user.nil? 
			redirect_to root_url
		elsif !current_user.nil?
			@articles = Article.notupdate.nottranslation.notstory.order('created_at DESC')
			@stories = Article.notupdate.nottranslation.story.order('created_at DESC')
			@toplevelstories = Article.notupdate.nottranslation.story.toplevelstory.order('created_at DESC')
		else
			redirect_to root_url
		end
	end
	
	def admin
		if current_user.nil? 
			redirect_to root_url
		elsif !current_user.nil?
			
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
				campaign_id: @article.campaign_id,
				plan_ids: ''
				)
		@articletweets = @article.tweets.order('created_at ASC')
		@articleupdates = @article.updates.published.order('created_at ASC')
		
		elsif current_user.nil?
			redirect_to root_url
		elsif current_user
			
		else
			redirect_to root_url
		end
	end

	# GET /articles/new
	def new
		if current_user.nil? 
			redirect_to root_url
		elsif !current_user.nil?
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
		elsif !current_user.nil?
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
	
	def email_article
		if params[:article][:email_to] == 'none'
					
		elsif params[:article][:email_to] == 'alert'
			if ["Notes"].include?@article.type.name
				User.emailsenglish.find_each(batch_size: 50) do |user|
					ArticleMailer.send_article_full(@article, user).deliver_now
				end
			elsif ["Apuntes"].include?@article.type.name
				User.emailsspanish.find_each(batch_size: 50) do |user|
					ArticleMailer.send_article_full(@article, user).deliver_now
				end
			elsif ["Update"].include?@article.type.name
				User.emailsall.emailsenglish.find_each(batch_size: 50) do |user|
					ArticleMailer.send_article_full(@article, user).deliver_now
				end
			elsif ["Actualización"].include?@article.type.name
				User.emailsall.emailsspanish.find_each(batch_size: 50) do |user|
					ArticleMailer.send_article_full(@article, user).deliver_now
				end
			elsif !["Notes", "Apuntes","Update", "Actualización"].include?@article.type.name
				if @article.language_id == 1
					User.emailsfull.emailsenglish.find_each(batch_size: 50) do |user|
						ArticleMailer.send_article_full(@article, user).deliver_now
					end
				elsif @article.language_id == 2
					User.emailsfull.emailsspanish.find_each(batch_size: 50) do |user|
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
				if ["Draft", "Editing"].include?(@article.status.name)
					
				elsif ["Published", "Updated"].include?(@article.status.name)
					email_article
					tweet_article
				else
				end
				format.html { redirect_to edit_article_path(@article), notice: 'Article was successfully updated.' }
				format.json { render :edit, status: :ok, location: @article }
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
			params.require(:article).permit(:alertmessage, :audio, :audioteaser, :body, :created_at, :campaign_id, :extras_audio, :extras_audioteaser, :extras_body, :headline, :image, :is_free, :language_id, :lede, :main_id, :original_id, :status_id, :story_id, :topstory, :type_id, :video)
		end
end