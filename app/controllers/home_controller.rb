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
			@frame_article = (@frame.language_id == 1)
			@frametranslation = @frame.translations.where(language_id: 1).first
			@frameoriginal = @frame.original
		else
			@frame = current_user.frame
			@frame_article = (@frame.language_id == 1)
			@frametranslation = @frame.translations.where(language_id: 1).first
			@frameoriginal = @frame.original
		end
		
		@url_stub = "/value/"
		@latesttop = Article.nottruth.notpatrons.english.topstory.published.lastone
		@latest = Article.notlatesttop.notupdate.nottruth.notpatrons.english.published.lasttwenty
		@latesttruth = Article.truth.english.published.lastten
		@types = Type.english.notupdate.notstory
		@rss = Article.all.order('created_at DESC')
		@latest_patrons_only = Article.patrons.english.order('created_at DESC').limit(5)

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
		
		@url_stub = "/valor/"
		@latesttop = Article.nottruth.notpatrons.spanish.topstory.published.lastone
		@latest = Article.notlatesttop.notupdate.nottruth.notpatrons.spanish.published.lasttwenty
		@latesttruth = Article.truth.spanish.published.lastten
		@types = Type.spanish.notupdate.notstory
		@rss = Article.all.spanish.published.order('created_at DESC')
		@latest_patrons_only = Article.patrons.spanish.order('created_at DESC').limit(5)
		
		respond_to do |format|
			format.html
			format.rss { render :layout => false }
		end
	end
	
	def eng
		@rss = Article.all.english.published.order('created_at DESC')
		respond_to do |format|
			format.html
			format.rss { render :layout => false }
		end
	end
	
	def audio
		@audioarticles = Article.audio.published.english.order('created_at DESC')
	end 

def audio_es
		@audioarticles = Article.audio.published.spanish.order('created_at DESC')
end 

end
