class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy]

  # GET /accounts
  # GET /accounts.json
  def index
    if current_user.nil? 
			redirect_to root_url
		elsif current_user.role == 1
			@accounts = Account.all
		else
			redirect_to root_url
		end
  end

  # GET /accounts/1
  # GET /accounts/1.json
  def show
    if current_user.nil? 
			redirect_to root_url
		elsif current_user.role == 1
			redirect_to edit_account_path(@account)
		else
			redirect_to root_url
		end
  end

  # GET /accounts/new
  def new
    if current_user.nil? 
			redirect_to root_url
		elsif current_user.role == 1
			@account = Account.new
		else
			redirect_to root_url
		end
    
    
  end
  
  def editor_modifies_accounts
    array2 = params[:email].split(/\n/)
		
		array2.each do |e|
  		user = User.find_by_email(e)
    	
    	if user.present?
    		if user.account_id.nil?
    		  account = Account.create!(
    		    account_status: params[:account_status],
    		    conversation_status: params[:conversation_status],
    		    account_status_date: Time.zone.now
    		    )
    		    
    		  user.update(
    		    account_id: account.id,
    		    account_role: 1
    		    )
    		elsif !Account.find_by_id(user.account_id).present?
    		  account = Account.create!(
    		    account_status: params[:account_status],
    		    conversation_status: params[:conversation_status],
    		    account_status_date: Time.zone.now
    		    )
    		    
    		  user.update(
    		    account_id: account.id,
    		    account_role: 1
    		    )
    		else
      		account = Account.find_by_id(user.account_id)
      		account.update(
      		  account_status: params[:account_status],
      		  conversation_status: params[:conversation_status],
      		  account_status_date: Time.zone.now
      		  )
    		end
  		else
  		  puts "user does not exist"
  		end
		end
		
		redirect_to accounts_path
  end
  
  # GET /accounts/1/edit
  def edit
    if current_user.nil? 
			redirect_to root_url
		elsif current_user.role == 1
			@accountowner = User.where(account_id: @account).where(account_role: 1)
		else
			redirect_to root_url
		end
  end

  # POST /accounts
  # POST /accounts.json
  def create
    @account = Account.new(account_params)

    respond_to do |format|
      if @account.save
        format.html { redirect_to @account, notice: 'Account was successfully created.' }
        format.json { render :show, status: :created, location: @account }
      else
        format.html { render :new }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /accounts/1
  # PATCH/PUT /accounts/1.json
  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to edit_account_path(@account), notice: 'Account was successfully updated.' }
        format.json { render :show, status: :ok, location: @account }
      else
        format.html { render :edit }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.json
  def destroy
    @account.destroy
    respond_to do |format|
      format.html { redirect_to accounts_url, notice: 'Account was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_params
      params.require(:account).permit(:account_status, :account_status_date, :conversation_status)
    end
end
