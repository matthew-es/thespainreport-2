class HomeController < ApplicationController
	def test
	end
	
	def index
		set_language_frame(1, nil)
		set_status(current_user) unless current_user.nil?
		placeholders
		
		@article_id = "0"

		@latestmain = Article.english.published.latestmain
		@podcast = Article.english.published.podcast.lastfive
		@patrons = Article.english.published.patrons.lastfive
		@free = Article.english.published.nottruth.notstory.notpatrons.notpodcast.notphoto.notvideo.lastfive
		@truth = Article.english.published.truth.lastfive
		
		@analysis = Article.english.published.analysis.lastten
		@dispatch = Article.english.published.dispatch.lastten
		@photo = Article.english.published.photo.lastten
		@long = Article.english.published.long.lastten
		@blog = Article.english.published.blog.lastten
		
		@rss = Article.published.english.order('created_at DESC')
		respond_to do |format|
			format.html
			format.rss { render :layout => false }
		end
	end
	
	def es
		set_language_frame(2, nil)
		set_status(current_user) unless current_user.nil?
		
		@article_id = "0"
		@latestmain = Article.spanish.published.latestmain
		@podcast = Article.spanish.published.podcast.lastfive
		@patrons = Article.spanish.published.patrons.lastfive
		@free = Article.spanish.published.nottruth.notstory.notpatrons.notpodcast.notphoto.notvideo.lastfive
		@truth = Article.spanish.published.truth.lastfive

		@analysis = Article.spanish.published.analysis.lastten
		@dispatch = Article.spanish.published.dispatch.lastten
		@photo = Article.spanish.published.photo.lastten
		@long = Article.spanish.published.long.lastten
		@blog = Article.spanish.published.blog.lastten

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
