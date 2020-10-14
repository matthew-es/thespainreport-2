module Uploads
    class TweetExisting
        def self.process(link)
        	require 'open-uri'
        	
        	extname = File.extname(link)
			basename = File.basename(link, extname)
        	
			file = Tempfile.new([basename, extname])
			file.binmode
			
			open(URI.parse(link)) do |data|  
			  file.write data.read
			end
			
			file.rewind
			file
			
        end
    end
end