xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
	xml.channel do
		xml.title "The Spain Report"
		xml.description "Indpendent reportings and analysis of news from Spain"
		xml.link root_url

		@rss.each do |article|
			xml.item do
				xml.title article.headline
				xml.description article.lede
				xml.pubDate article.created_at.to_s(:rfc822)
				xml.link article_url(article)
				xml.guid article_url(article)
			end
		end
	end
end