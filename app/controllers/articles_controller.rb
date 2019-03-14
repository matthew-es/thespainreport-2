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
			params.require(:article).permit(:audio, :audioteaser, :body, :created_at, :campaign_id, :extras_audio, :extras_audioteaser, :extras_body, :headline, :image, :is_free, :language_id, :lede, :main_id, :original_id, :status_id, :story_id, :topstory, :type_id, :video)
		end
end