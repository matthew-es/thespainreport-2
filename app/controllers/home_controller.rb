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
    
    @latesttop = Article.notnotes.english.topstory.published.lastone
    @latest = Article.notlatesttop.notupdate.notnotes.english.published.lasttwenty
    @latestnotes = Article.notes.english.published.lastten
    @types = Type.english.notupdate.notstory
    @rss = Article.all.order('created_at DESC')
    
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
    
    @latesttop = Article.notnotes.spanish.topstory.published.lastone
    @latest = Article.notlatesttop.notupdate.notnotes.spanish.published.lasttwenty
    @latestnotes = Article.notes.spanish.published.lastten
    @types = Type.spanish.notupdate.notstory
    @rss = Article.all.spanish.published.order('created_at DESC')
    
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
