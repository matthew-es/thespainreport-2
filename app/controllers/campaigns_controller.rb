class CampaignsController < ApplicationController
  before_action :set_campaign, only: [:show, :edit, :update, :destroy]
  
  def campaign_elements
    @languages = Language.all.order(:name)
    @campaigns = Campaign.original.order(:created_at)
  end
  
  
  # GET /campaigns
  # GET /campaigns.json
  def index
    if current_user.nil? 
			redirect_to root_url
		elsif current_user.role == 1
			campaign_elements
		else
			redirect_to root_url
		end
  end

  # GET /campaigns/1
  # GET /campaigns/1.json
  def show
    if current_user.nil? 
			redirect_to root_url
		elsif current_user.role == 1
			
		else
			redirect_to root_url
		end
  end

  # GET /campaigns/new
  def new
    if current_user.nil? 
			redirect_to root_url
		elsif current_user.role == 1
			@campaign = Campaign.new
      campaign_elements
		else
			redirect_to root_url
		end
  end

  # GET /campaigns/1/edit
  def edit
    if current_user.nil? 
			redirect_to root_url
		elsif current_user.role == 1
			campaign_elements
		else
			redirect_to root_url
		end
  end

  # POST /campaigns
  # POST /campaigns.json
  def create
    @campaign = Campaign.new(campaign_params)

    respond_to do |format|
      if @campaign.save
        format.html { redirect_to @campaign, notice: 'Campaign was successfully created.' }
        format.json { render :show, status: :created, location: @campaign }
      else
        format.html { render :new }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /campaigns/1
  # PATCH/PUT /campaigns/1.json
  def update
    respond_to do |format|
      if @campaign.update(campaign_params)
        format.html { redirect_to @campaign, notice: 'Campaign was successfully updated.' }
        format.json { render :show, status: :ok, location: @campaign }
      else
        format.html { render :edit }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /campaigns/1
  # DELETE /campaigns/1.json
  def destroy
    @campaign.destroy
    respond_to do |format|
      format.html { redirect_to campaigns_url, notice: 'Campaign was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_campaign
      @campaign = Campaign.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def campaign_params
      params.require(:campaign).permit(:buttontext, :image, :name, :teaser, :social, :deal, :riskreversal, :language_id, :original_id)
    end
end
