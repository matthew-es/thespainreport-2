class HomeController < ApplicationController
	def patreon
		redirect_to root_url
	end
	
	def index
		Visit.create(
				referer: request.headers["HTTP_REFERER"],
				article_id: 1000000,
				frame_id: 1000000,
				plan_ids: ''
				)
		
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
		@latesttop = Article.nottruth.notpatrons.english.topstory.published.lastone
		@latest = Article.notlatesttop.notupdate.nottruth.notpatrons.english.published.lasttwenty
		@latesttruth = Article.truth.english.published.lastten
		@types = Type.english.notupdate.notstory
		@latest_patrons_only = Article.patrons.english.order('created_at DESC').limit(5)
		
		@rss = Article.published.english.order('created_at DESC')
		respond_to do |format|
			format.html
			format.rss { render :layout => false }
		end
	end
	
	def es
		Visit.create(
				referer: request.headers["HTTP_REFERER"],
				article_id: 1000001,
				frame_id: 1000001,
				plan_ids: ''
				)
		
		if current_user.nil? || current_user.frame.blank?
			@frame = Frame.find_by(link_slug: "guarantee")
			
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
		@latesttop = Article.nottruth.notpatrons.spanish.topstory.published.lastone
		@latest = Article.notlatesttop.notupdate.nottruth.notpatrons.spanish.published.lasttwenty
		@latesttruth = Article.truth.spanish.published.lastten
		@types = Type.spanish.notupdate.notstory
		@latest_patrons_only = Article.patrons.spanish.order('created_at DESC').limit(5)
		
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
