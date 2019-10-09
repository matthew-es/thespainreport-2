class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :edit, :update, :destroy]

  # GET /invoices
  # GET /invoices.json
  def index
    if current_user.nil? 
			redirect_to root_url
		elsif current_user.role == 1
			@invoices = Invoice.all
		else
			redirect_to root_url
		end
  end

  # GET /invoices/1
  # GET /invoices/1.json
  def show
    if current_user.nil? 
			redirect_to root_url
		elsif current_user.role == 1
			
		else
			redirect_to root_url
		end
  end

  # GET /invoices/new
  def new
    if current_user.nil? 
			redirect_to root_url
		elsif current_user.role == 1
			@invoice = Invoice.new
		else
			redirect_to root_url
		end
  end

  # GET /invoices/1/edit
  def edit
    if current_user.nil? 
			redirect_to root_url
		elsif current_user.role == 1
			
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
      params.require(:invoice).permit(:tax_percent, :plan_amount, :tax_amount, :total_amount, :account_id, :subscription_id)
    end
end
