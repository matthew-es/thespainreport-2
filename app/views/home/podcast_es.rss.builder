xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0", 
	"xmlns:itunes" => "http://www.itunes.com/dtds/podcast-1.0.dtd",
	"xmlns:spotify" => "https://www.spotify.com/ns/rss",
	"xmlns:content" => "http://purl.org/rss/1.0/modules/content/",
	"xmlns:dcterms" => "https://purl.org/dc/terms/",
	"xmlns:media" => "https://search.yahoo.com/mrss/" do
	
	xml.channel do
		xml.title "The Spain Report"
		xml.description "Matthew Bennett informa sobre y analiza España"
		xml.copyright "Matthew Bennett"
		xml.language "es"
		xml.link "https://www.thespainreport.es"
		
		xml.itunes :title, "The Spain Report"
		xml.itunes :summary, "Matthew Bennett informa sobre y analiza España"
		xml.itunes :author, "Matthew Bennett"
		xml.itunes :image, ""
		xml.itunes :category, :text => 'News' do
	      xml.itunes :category, :text => 'Daily News'
	      xml.itunes :category, :text => 'News Commentary'
	    end
		xml.itunes :owner do
			xml.itunes :name, "Matthew Bennett"
			xml.itunes :email, "matthew@thespainreport.es"
		end
		xml.itunes :type, "episodic"
		xml.itunes :explicit, "false"
		
		xml.spotify :countryOfOrigin, "es gb ie us ca au nz"
		
		@rss.each do |article|
			xml.item do
				xml.enclosure :url => "https://audio.thespainreport.es/" + article.audio_file, :length => article.audio_file_length, :type => article.audio_file_type
				
				xml.title article.headline
				xml.description article.audio_episode_notes
				
				xml.itunes :title, article.headline
				xml.itunes :summary, article.lede
				xml.itunes :author, "Matthew Bennett"
				xml.itunes :episode, article.audio_file_episode
				xml.itunes :episodeType, "full"
				xml.itunes :duration, article.audio_file_duration
				xml.itunes :explicit, "false"
				
				xml.pubDate article.created_at.to_s(:rfc822)
				xml.link article_url(article)
				xml.guid({:isPermaLink => "false"}, "https://www.thespainreport.es/" + (article.id + article.created_at.to_i).to_s)
			end
		end
	end
end