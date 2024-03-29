class CountriesController < ApplicationController
  before_action :set_country, only: [:show, :edit, :update, :destroy]

  # GET /countries
  # GET /countries.json
  def index
    if current_user.nil? 
			redirect_to root_url
		elsif current_user.status == 1
			@countries = Country.all.order("name_en ASC")
		else
			redirect_to root_url
		end
  end

  # GET /countries/1
  # GET /countries/1.json
  def show
    if current_user.nil? 
			redirect_to root_url
		elsif current_user.status == 1
			
		else
			redirect_to root_url
		end
  end

  # GET /countries/new
  def new
    if current_user.nil? 
			redirect_to root_url
		elsif current_user.status == 1
			@country = Country.new
		else
			redirect_to root_url
		end
  end

  # GET /countries/1/edit
  def edit
    if current_user.nil? 
			redirect_to root_url
		elsif current_user.status == 1
			
		else
			redirect_to root_url
		end
  end

  # POST /countries
  # POST /countries.json
  def create
    @country = Country.new(country_params)

    respond_to do |format|
      if @country.save
        format.html { redirect_to countries_url, notice: 'Country was successfully created.' }
        format.json { render :index, status: :created, location: @country }
      else
        format.html { render :new }
        format.json { render json: @country.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /countries/1
  # PATCH/PUT /countries/1.json
  def update
    respond_to do |format|
      if @country.update(country_params)
        format.html { redirect_to countries_url, notice: 'Country was successfully updated.' }
        format.json { render :index, status: :ok, location: @country }
      else
        format.html { render :edit }
        format.json { render json: @country.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /countries/1
  # DELETE /countries/1.json
  def destroy
    @country.destroy
    respond_to do |format|
      format.html { redirect_to countries_url, notice: 'Country was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_country
      @country = Country.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def country_params
      params.require(:country).permit(:country_code, :name_en, :name_es, :tax_percent)
    end
end
