class HomeController < ApplicationController
	def patreon
		redirect_to root_url
	end
	
	def index
		if current_user.nil? || current_user.frame.blank?
			@frame = Frame.find_by(link_slug: "guarantee")
			@frame_id = @frame.id
			@frame_article = (@frame.language_id == 1)
			@frametranslation = @frame.translations.where(language_id: 1).first
			@frameoriginal = @frame.original
		else
			@frame = current_user.frame
			@frame_id = @frame.id
			@frame_article = (@frame.language_id == 1)
			@frametranslation = @frame.translations.where(language_id: 1).first
			@frameoriginal = @frame.original
		end
		
		@set_language = 1
		@url_stub = "/value/"
		@plans = Plan.english.all
		@article_id = "0"
		
		@latesttop = Article.english.published.topstory.lastone
		@podcast = Article.english.published.podcast.lastfive
		@patrons = Article.english.published.patrons.lastfive
		@free = Article.english.published.notlatesttop.notupdates.nottruth.notstory.notpatrons.notpodcast.lastfive
		@truth = Article.english.published.truth.lastfive
		
		@rss = Article.published.english.order('created_at DESC')
		respond_to do |format|
			format.html
			format.rss { render :layout => false }
		end
	end
	
	def es
		if current_user.nil? || current_user.frame.blank?
			@frame = Frame.find_by(link_slug: "garantizar")
			@frame_id = @frame.id
			@frame_article = (@frame.language_id == 2)
			@frametranslation = @frame.translations.where(language_id: 2).first
			@frameoriginal = @frame.original
		else
			@frame = current_user.frame
			@frame_article = (@frame.language_id == 2)
			@frametranslation = @frame.translations.where(language_id: 2).first
			@frameoriginal = @frame.original
		end
		
		@set_language = 2
		@url_stub = "/valor/"
		@plans = Plan.spanish.all
		@article_id = "0"
		
		@latesttop = Article.spanish.published.topstory.lastone
		@podcast = Article.spanish.published.podcast.lastfive
		@patrons = Article.spanish.published.patrons.lastfive
		@free = Article.spanish.published.notlatesttop.notupdates.nottruth.notstory.notpatrons.notpodcast.lastfive
		@truth = Article.spanish.published.truth.lastfive
		
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
