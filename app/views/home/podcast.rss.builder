xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
	xml.channel do
		xml.title "The Spain Report"
		xml.description "Indpendent reporting and analysis of news from Spain"
		xml.copyright "Matthew Bennett"
		xml.language "en"
		
		
		xml.itunes :title, "The Spain Report"
		xml.itunes :summary, "Indpendent reporting and analysis of news from Spain"
		xml.itunes :author, "Matthew Bennett"
		xml.itunes :image, ""
		xml.itunes :category, :text => 'News' do
	      xml.itunes :category, :text => 'Daily News'
	      xml.itunes :category, :text => 'News Commentary'
	    end
		xml.link "https://www.thespainreport.es"
		
		xml.itunes :owner do
			xml.itunes :name, "Matthew Bennett"
			xml.itunes :email, "matthew@thespainreport.es"
		end
		xml.itunes :type, "episodic"
		xml.itunes :explicit, "false"
		
		@rss.each do |article|
			xml.item do
				xml.enclosure :url => 'https://audio.thespainreport.es/' + article.audio_file, :length => "", :type => ""
				
				xml.title article.headline
				xml.description article.lede
				xml.content :encoded, article.lede
				
				xml.itunes :title, article.headline
				xml.itunes :episode, ""
				xml.itunes :episodeType, "full"
				xml.itunes :duration, ""
				xml.itunes :explicit, "false"
				
				xml.pubDate article.created_at.to_s(:rfc822)
				xml.link article_url(article)
				xml.guid article.id + article.created_at.to_i
			end
		end
	end
end