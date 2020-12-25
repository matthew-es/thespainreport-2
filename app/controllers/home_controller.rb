class HomeController < ApplicationController
	def index
		set_language_frame(1, Frame.find_by(link_slug: "guarantee").id)
		set_status(current_user) unless current_user.nil?
		set_country
		
		@article_id = "0"
		@latestmain = Article.english.published.latestmain
		@podcast = Article.english.published.podcast.notlatestpodcast.lastfive
		@patrons = Article.english.published.patrons.lastfive
		@free = Article.english.published.nottruth.notstory.notpatrons.notpodcast.notphoto.notvideo.lastfive
		@truth = Article.english.published.truth.lastfive
		@photos = Article.english.published.photo.lastfive
		@videos = Article.english.published.video.lastfive
		
		@rss = Article.published.english.order('created_at DESC')
		respond_to do |format|
			format.html
			format.rss { render :layout => false }
		end
	end
	
	def es
		set_language_frame(2, Frame.find_by(link_slug: "garantizar").id)
		set_status(current_user) unless current_user.nil?
		set_country
		
		@article_id = "0"
		@latestmain = Article.spanish.published.latestmain
		@podcast = Article.spanish.published.podcast.lastfive
		@patrons = Article.spanish.published.patrons.lastfive
		@free = Article.spanish.published.nottruth.notstory.notpatrons.notpodcast.notphoto.notvideo.lastfive
		@truth = Article.spanish.published.truth.lastfive
		@photos = Article.spanish.published.photo.lastfive
		@videos = Article.spanish.published.video.lastfive
		
		@rss = Article.published.spanish.order('created_at DESC')
		respond_to do |format|
			format.html
			format.rss { render :layout => false }
		end
	end
	
	def podcast
		@rss = Article.published.english.podcast.order('created_at DESC')
		respond_to do |format|
			format.html
			format.rss { render :layout => false }
		end
	end
	
	def podcast_mp3
		@rss = Article.published.english.podcast.order('created_at DESC')
		respond_to do |format|
			format.html
			format.rss { render :layout => false }
		end
	end

	def es_podcast
			@rss = Article.published.spanish.podcast.order('created_at DESC')
			respond_to do |format|
				format.html
				format.rss { render :layout => false }
			end
	end
	
	def es_podcast_mp3
			@rss = Article.published.spanish.podcast.order('created_at DESC')
			respond_to do |format|
				format.html
				format.rss { render :layout => false }
			end
	end 

end
