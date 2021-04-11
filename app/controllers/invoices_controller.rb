class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :edit, :update, :destroy]
  
  def apply_invoice_details
	current_user.account.invoices.each do |i|
		if i.invoice_customer_name.empty?
			i.update(
				invoice_customer_name: current_user.account.invoice_account_name
				)
		end
		
		if i.invoice_customer_tax_id.empty?
			i.update(
				invoice_customer_tax_id: current_user.account.invoice_account_tax_id
				)
		end
		
		if i.invoice_customer_address.empty?
			i.update(
				invoice_customer_address: current_user.account.invoice_account_address
				)
		end
	end
	
	redirect_to edit_user_path(current_user)
  end
  
  # GET /invoices
  # GET /invoices.json
  def index
	if current_user.nil? 
			redirect_to root_url
		elsif current_user.status == 1
			@invoices = Invoice.all.order('created_at DESC')
		else
			redirect_to root_url
		end
  end

  # GET /invoices/1
  # GET /invoices/1.json
  def show
	@invoice = Invoice.find(params[:id])
		set_language_frame(current_user.sitelanguage, current_user.frame.id)
		set_status(current_user) unless current_user.nil?
		
		if current_user.nil?
			redirect_to root_url
		
		elsif current_user.status == 1
		
		elsif @invoice.account.user_id != current_user.id
			redirect_to edit_user_path(current_user)
		elsif @invoice.account.user_id == current_user.id
			puts @invoice.account.user_id
		else
			redirect_to root_url
		end
  end

  # GET /invoices/new
  def new
	if current_user.nil? 
			redirect_to root_url
		elsif current_user.status == 1
			@invoice = Invoice.new
		else
			redirect_to root_url
		end
  end

  # GET /invoices/1/edit
  def edit
	if current_user.nil? 
			redirect_to root_url
		elsif current_user.status == 1
			
		else
			redirect_to root_url
		end
  end

  # POST /invoices
  # POST /invoices.json
  def create
	@invoice = Invoice.new(invoice_params)

	respond_to do |format|
	  if @invoice.save
		format.html { redirect_to @invoice, notice: 'Invoice was successfully created.' }
		format.json { render :show, status: :created, location: @invoice }
	  else
		format.html { render :new }
		format.json { render json: @invoice.errors, status: :unprocessable_entity }
	  end
	end
  end

  # PATCH/PUT /invoices/1
  # PATCH/PUT /invoices/1.json
  def update
	respond_to do |format|
	  if @invoice.update(invoice_params)
		format.html { redirect_to @invoice, notice: 'Invoice was successfully updated.' }
		format.json { render :show, status: :ok, location: @invoice }
	  else
		format.html { render :edit }
		format.json { render json: @invoice.errors, status: :unprocessable_entity }
	  end
	end
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.json
  def destroy
	@invoice.destroy
	respond_to do |format|
	  format.html { redirect_to invoices_url, notice: 'Invoice was successfully destroyed.' }
	  format.json { head :no_content }
	end
  end

  private
	# Use callbacks to share common setup or constraints between actions.
	def set_invoice
	  @invoice = Invoice.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def invoice_params
	  params.require(:invoice).permit(
		:invoice_year, :invoice_month, :invoice_day, :invoice_number, :invoice_status,
		:invoice_customer_address, :invoice_customer_tax_id, :invoice_customer_name, :invoice_concept,
		:invoice_from_name, :invoice_from_address, :invoice_from_tax_id,
		:invoice_type, :invoice_operation,
		:tax_percent, :plan_amount, :tax_amount, :total_amount, :account_id, :subscription_id, :payment_id)
	end
end
