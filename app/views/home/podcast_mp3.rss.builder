xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0", 
	"xmlns:itunes" => "http://www.itunes.com/dtds/podcast-1.0.dtd",
	"xmlns:spotify" => "https://www.spotify.com/ns/rss",
	"xmlns:googleplay" => "http://www.google.com/schemas/play-podcasts/1.0",
	"xmlns:content" => "http://purl.org/rss/1.0/modules/content/",
	"xmlns:dcterms" => "https://purl.org/dc/terms/",
	"xmlns:media" => "https://search.yahoo.com/mrss/" do
	
	xml.channel do
		podcast_image = "https://image.thespainreport.es/bennett_in_spain_artwork_map.png"
		podcast_description = "Matthew Bennett analyses the news from Spain."
		podcast_author = "Matthew Bennett"
		podcast_title = "Bennett in Spain"

		xml.title podcast_title
		xml.description podcast_description
		xml.copyright podcast_author
		xml.language "en"
		xml.link "https://www.thespainreport.es"
		
		xml.itunes :title, podcast_title
		xml.itunes :summary, podcast_description
		xml.itunes :author, podcast_author
		xml.itunes :image, :href => podcast_image
		xml.itunes :category, :text => 'News' do
	      xml.itunes :category, :text => 'Daily News'
	      xml.itunes :category, :text => 'News Commentary'
	    end
		xml.itunes :owner do
			xml.itunes :name, podcast_author
			xml.itunes :email, "matthew@thespainreport.es"
		end
		xml.itunes :type, "episodic"
		xml.itunes :explicit, "false"
		
		xml.spotify :countryOfOrigin, "es gb ie us ca au nz"
		
		xml.googleplay :author, podcast_author
		xml.googleplay :description, podcast_description
		xml.googleplay :image, :href => podcast_image
		xml.googleplay :category, :text => "News &amp; Politics"
		
		@rss.each do |article|
			show_links = "<ol>
							<li><a href=\"https://www.thespainreport.es/value\">Guarantee journalism here</a></li>
							<li><a href=\"https://twitter.com/matthewbennett\">Follow Matthew on Twitter</a></li>
						 </ol>"
			
			xml.item do
				xml.enclosure :url => "https://audio.thespainreport.es/" + article.audio_file_mp3, :length => article.audio_file_mp3_length, :type => article.audio_file_mp3_type
				
				xml.title article.headline
				if article.audio_episode_notes.nil?
					xml.description {xml.cdata!(article.lede + show_links)}
				else
					xml.description {xml.cdata!(article.audio_episode_notes + show_links)}
				end
				xml.itunes :title, article.headline
				xml.itunes :summary, article.lede
				xml.itunes :author, "Matthew Bennett"
				xml.itunes :episode, article.audio_file_episode
				xml.itunes :episodeType, "full"
				xml.itunes :duration, article.audio_file_duration
				xml.itunes :explicit, "false"
				
				xml.googleplay :description, article.lede
				
				xml.pubDate article.created_at.to_s(:rfc822)
				xml.link article_url(article)
				xml.guid({:isPermaLink => "false"}, "https://www.thespainreport.es/" + (article.id + article.created_at.to_i).to_s)
			end
		end
	end
end