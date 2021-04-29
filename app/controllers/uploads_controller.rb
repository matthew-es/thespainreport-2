class UploadsController < ApplicationController
	before_action :set_upload, only: [:show, :edit, :update, :destroy]
	
	def get_print
		@upload = Upload.find(params[:id])
		@user = User.find(current_user.id)
		set_language_frame(@user.sitelanguage, @user.frame.id)
	end
	
	def confirm_print
		@upload = Upload.find(params[:id])
		@user = User.find(current_user.id)
		
		puts "ORDER PRINT: " + @upload.id.to_s + " FOR USER " + @user.email
		
		has_prints = @user.prints.where(order_date: DateTime.now.in_time_zone.beginning_of_month..DateTime.now.in_time_zone.end_of_month)
		latest_print = has_prints.last
		
		if !has_prints.nil? && (has_prints.count > 0)
			latest_print.update(
				upload_id: @upload.id,
				order_date: DateTime.now
				)
		else
			Print.create(
				user_id: @user.id,
				upload_id: @upload.id,
				order_date: DateTime.now
				)
		end
		
		redirect_to edit_user_path(@user)
	end
	
	def get_prints
		if current_user.nil? 
			redirect_to root_url
		elsif current_user.status == 1
			@prints = Print.select('upload_id').group(:upload_id).count
			puts @prints
		else
			redirect_to root_url
		end
	end
	
	# GET /uploads
	# GET /uploads.json
	def index
		if current_user.nil? 
			redirect_to root_url
		elsif current_user.status == 1
			@uploads = Upload.all.order('created_at DESC')
			@mains = Upload.main.order('created_at DESC')
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
			@mains = Upload.all.order('created_at DESC')
		else
			redirect_to root_url
		end
	end
	
	def s3_buckets
		image_bucket = 'image.thespainreport.es'
	    audio_bucket = 'audio.thespainreport.es'
	    document_bucket = 'pdf.thespainreport.es'
		
		case @extension_to_analyse
	    	when '.aac' then @file_content_type = "audio/aac"; @bucket = audio_bucket
	    	when '.m4a' then @file_content_type = "audio/m4a"; @bucket = audio_bucket
	    	when '.mp3' then @file_content_type = "audio/mpeg"; @bucket = audio_bucket
	    	when '.pdf' then @file_content_type = "application/pdf"; @bucket = document_bucket
	    	when '.gif' then @file_content_type = "image/gif"; @bucket = image_bucket
	    	when '.png' then @file_content_type = "image/png"; @bucket = image_bucket
	    	when '.jpg' then @file_content_type = "image/jpeg"; @bucket = image_bucket
	    	when '.jpeg' then @file_content_type = "image/jpeg"; @bucket = image_bucket
	    end
	end
	
	def upload_files
		@data = params[:data]
		@data.each do |d|
			# Create a reference for the temporary file
			tf = "#{Rails.root}/tmp/#{d.original_filename}"
	  
			# Writes tmp file if doesn't exist
			File.open(tf, 'wb') do |f|
				f.write d.read
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
			@upload.save
		end

		respond_to do |format|
			if @upload.save
				format.html { redirect_to uploads_url, notice: 'Upload was successfully created.' }
				format.json { render :index, status: :created}
			else
				format.html { redirect_to uploads_url, notice: 'Problem with upload...' }
				format.json { render json: @upload.errors, status: :unprocessable_entity }
			end
		end
	end
	
	
	# POST /uploads
	# POST /uploads.json
	def create
		@upload = Upload.new(upload_params)
		
		respond_to do |format|
			if @upload.save
				format.html { redirect_to uploads_url, notice: 'Upload was successfully created.' }
				format.json { render :index, status: :created}
			else
				format.html { redirect_to uploads_url, notice: 'Problem with upload...' }
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
		@upload.versions.each do |v|
			v_file_name = File.basename(v.data)
			@extension_to_analyse = File.extname(v.data)
			s3_buckets
			s3 = Aws::S3::Client.new
			s3.delete_object(key: v_file_name, bucket: @bucket)
			
			v.destroy
		end

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
			params.require(:upload).permit(:data, :file_size, :file_type, :main_id, :version, :article_ids => [])
		end
end
