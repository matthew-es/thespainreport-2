class SubscriptionsController < ApplicationController
  before_action :set_subscription, only: [:show, :edit, :update, :destroy]

  # GET /subscriptions
  # GET /subscriptions.json
  def index
    if current_user.nil? 
			redirect_to root_url
		elsif current_user.status == 1
			@subscriptions = Subscription.all.order('created_at DESC')
		else
			redirect_to root_url
		end
  end

  # GET /subscriptions/1
  # GET /subscriptions/1.json
  def show
     if current_user.nil? 
			redirect_to root_url
		elsif current_user.status == 1
			
		else
			redirect_to root_url
		end
  end

  # GET /subscriptions/new
  def new
     if current_user.nil? 
			redirect_to root_url
		elsif current_user.status == 1
			@subscription = Subscription.new
		else
			redirect_to root_url
		end
  end

  # GET /subscriptions/1/edit
  def edit
     if current_user.nil? 
			redirect_to root_url
		elsif current_user.status == 1
			
		else
			redirect_to root_url
		end
  end

  # POST /subscriptions
  # POST /subscriptions.json
  def create
    @subscription = Subscription.new(subscription_params)

    respond_to do |format|
      if @subscription.save
        format.html { redirect_to @subscription, notice: 'Subscription was successfully created.' }
        format.json { render :show, status: :created, location: @subscription }
      else
        format.html { render :new }
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subscriptions/1
  # PATCH/PUT /subscriptions/1.json
  def update
    respond_to do |format|
      if @subscription.update(subscription_params)
        format.html { redirect_to @subscription, notice: 'Subscription was successfully updated.' }
        format.json { render :show, status: :ok, location: @subscription }
      else
        format.html { render :edit }
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subscriptions/1
  # DELETE /subscriptions/1.json
  def destroy
    @subscription.destroy
    respond_to do |format|
      format.html { redirect_to subscriptions_url, notice: 'Subscription was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subscription
      @subscription = Subscription.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subscription_params
      params.require(:subscription).permit(
        :account_id, :article_id, :plan_amount, :vat_country, :vat_rate, :vat_amount, :total_amount, :frame_id, :frame_name, :frame_buttontext, 
        :frame_slug, :card_country, :latest_paid_date, :ip_country, :ip_address, :residence_country, :next_payment_date, :last_payment_date, :is_active,
        :motivation_general_environment, :motivation_specific_brand, :article_from_server
        )
    end
end