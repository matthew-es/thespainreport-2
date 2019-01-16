class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  
  # GET /articles
  # GET /articles.json
  def article_elements
    @types = Type.all.order(:name)
    @statuses = Status.all.order(:name)
    @languages = Language.all.order(:name)
    @stories = Story.all.order(:title)
    @articles = Article.original.order(:created_at)
    @mainarticles = Article.all.order(:created_at)
    @campaigns = Campaign.all.order(:name)
  end
  
  def index
    @articles = Article.original.order(:created_at)
  end
  
  def admin
    article_elements
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
  end

  # GET /articles/new
  def new
    @article = Article.new
    article_elements
  end

  # GET /articles/1/edit
  def edit
    article_elements
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
      params.require(:article).permit(:body, :campaign_id, :headline, :language_id, :lede, :is_free, :main_id, :original_id, :status_id, :topstory, :type_id, :story_ids => [])
    end
end