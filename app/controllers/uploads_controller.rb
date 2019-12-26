class UploadsController < ApplicationController
	before_action :set_upload, only: [:show, :edit, :update, :destroy]

	# GET /uploads
	# GET /uploads.json
	def index
		if current_user.nil? 
			redirect_to root_url
		elsif current_user.status == 1
			@uploads = Upload.all.order('created_at DESC')
		else
			redirect_to root_url
		end
	end

	# GET /uploads/1
	# GET /uploads/1.json
	def show
		if current_user.nil? 
			redirect_to root_url
		elsif current_user.status == 1
			
		else
			redirect_to root_url
		end
	end

	# GET /uploads/new
	def new
		if current_user.nil? 
			redirect_to root_url
		elsif current_user.status == 1
			@upload = Upload.new
		else
			redirect_to root_url
		end
	end

	# GET /uploads/1/edit
	def edit
		if current_user.nil? 
			redirect_to root_url
		elsif current_user.status == 1
			
		else
			redirect_to root_url
		end
	end
	
	def s3_buckets
		image_bucket = 'image.thespainreport.es'
	    audio_bucket = 'audio.thespainreport.es'
	    document_bucket = 'pdf.thespainreport.es'
		
		case @extension_to_analyse
	    	when '.mp3' then @file_content_type = "audio/mpeg"; @bucket = audio_bucket
	    	when '.pdf' then @file_content_type = "application/pdf"; @bucket = document_bucket
	    	when '.gif' then @file_content_type = "image/gif"; @bucket = image_bucket
	    	when '.png' then @file_content_type = "image/png"; @bucket = image_bucket
	    	when '.jpg' then @file_content_type = "image/jpeg"; @bucket = image_bucket
	    	when '.jpeg' then @file_content_type = "image/jpeg"; @bucket = image_bucket
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
		how_big = File.size(tf)
		
		# Open S3, sort out bucket, create object, upload to object
		s3 = Aws::S3::Resource.new()
	    file_name = File.basename(tf)
	    @extension_to_analyse = File.extname(tf)
	    s3_buckets
	    
	    obj = s3.bucket(@bucket).object(file_name)
	    obj.upload_file(tf, content_type: @file_content_type)
	    
	    # Create the database row in Rails
		@upload = Upload.new(
				data: obj.public_url,
				file_size: how_big,
				file_type: @file_content_type
			)

		respond_to do |format|
			if @upload.save
				format.html { redirect_to uploads_url, notice: 'Upload was successfully created.' }
				format.json { render :index, status: :created, location: @upload }
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
		file_name = File.basename(@upload.data)
		@extension_to_analyse = File.extname(@upload.data)
		s3_buckets
		
		s3 = Aws::S3::Client.new
		s3.delete_object(key: file_name, bucket: @bucket)
		
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
			params.require(:upload).permit(:data, :file_size, :file_type)
		end
end
