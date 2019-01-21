class UploadsController < ApplicationController
	before_action :set_upload, only: [:show, :edit, :update, :destroy]

	# GET /uploads
	# GET /uploads.json
	def index
		if current_user.nil? 
			redirect_to root_url
		elsif !current_user.nil?
			@uploads = Upload.all
		else
			redirect_to root_url
		end
	end

	# GET /uploads/1
	# GET /uploads/1.json
	def show
		if current_user.nil? 
			redirect_to root_url
		elsif !current_user.nil?
			
		else
			redirect_to root_url
		end
	end

	# GET /uploads/new
	def new
		if current_user.nil? 
			redirect_to root_url
		elsif !current_user.nil?
			@upload = Upload.new
		else
			redirect_to root_url
		end
	end

	# GET /uploads/1/edit
	def edit
		if current_user.nil? 
			redirect_to root_url
		elsif !current_user.nil?
			
		else
			redirect_to root_url
		end
	end
	
	
	# POST /uploads
	# POST /uploads.json
	def create
		# Create a reference for the temporary file
		tf = "#{Rails.root}/tmp/#{params[:data].original_filename}"
  
		# Writes tmp file if doesn't exist
		File.open(tf, 'wb') do |f|
			f.write params[:data].read
		end
		
		# Put it on S3
		s3 = Aws::S3::Resource.new()
	    bucket = 'images.thespainreport.com'
	    name = File.basename(tf)
	    obj = s3.bucket(bucket).object(name)
	    obj.upload_file(tf)
	    
	    # Create the database row in Rails
		@upload = Upload.new(
				data: obj.public_url
			)

		respond_to do |format|
			if @upload.save
				format.html { redirect_to @upload, notice: 'Upload was successfully created.' }
				format.json { render :show, status: :created, location: @upload }
			else
				format.html { render :new }
				format.json { render json: @upload.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT /uploads/1
	# PATCH/PUT /uploads/1.json
	def update
		respond_to do |format|
			if @upload.update(upload_params)
				format.html { redirect_to @upload, notice: 'Upload was successfully updated.' }
				format.json { render :show, status: :ok, location: @upload }
			else
				format.html { render :edit }
				format.json { render json: @upload.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /uploads/1
	# DELETE /uploads/1.json
	def destroy
		@upload.destroy
		respond_to do |format|
			format.html { redirect_to uploads_url, notice: 'Upload was successfully destroyed.' }
			format.json { head :no_content }
		end
	end

	private
		# Use callbacks to share common setup or constraints between actions.
		def set_upload
			@upload = Upload.find(params[:id])
		end

		# Never trust parameters from the scary internet, only allow the white list through.
		def upload_params
			params.require(:upload).permit(:data)
		end
end
