module Uploads
    class UploadFile
        def self.process(upload, version, main)

            # Grab the image from the form field, write it to temporary folder
			tf = "#{Rails.root}/tmp/#{upload.original_filename}"
			
			# What type of file is it and where shall we put it?
			what_type_of_file = File.extname(tf)
			
			image_bucket = 'image.thespainreport.es'
	    	audio_bucket = 'audio.thespainreport.es'
	    	document_bucket = 'pdf.thespainreport.es'
		
			case what_type_of_file
		    	when '.aac' then file_content_type = "audio/aac"; bucket = audio_bucket
		    	when '.m4a' then file_content_type = "audio/m4a"; bucket = audio_bucket
		    	when '.mp3' then file_content_type = "audio/mpeg"; bucket = audio_bucket
		    		
		    	when '.pdf' then file_content_type = "application/pdf"; bucket = document_bucket
		    	
		    	when '.gif' then file_content_type = "image/gif"; bucket = image_bucket
		    	when '.png' then file_content_type = "image/png"; bucket = image_bucket
		    	when '.jpg' then file_content_type = "image/jpeg"; bucket = image_bucket
		    	when '.jpeg' then file_content_type = "image/jpeg"; bucket = image_bucket
		    end
			
			# Write the file, measure it
			File.open(tf, 'wb') do |f|
				f.write upload.read
			end
			how_big = File.size(tf)
			
			# Put the image on S3
			s3 = Aws::S3::Resource.new()
			name = File.basename(tf)
			obj = s3.bucket(bucket).object(name)
			obj.upload_file(tf)
			
			# Create a new upload entry in Rails database, for use elsewhere
			an_upload = Upload.new(
					data: obj.public_url,
					file_type: file_content_type,
					file_size: how_big,
					version: version,
					main_id: main
				)
			an_upload.save
			
			# Make the information available to the method again
			an_upload
			
        end
    end
end