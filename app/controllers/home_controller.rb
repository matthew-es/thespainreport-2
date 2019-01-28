class HomeController < ApplicationController
  def patreon
    redirect_to root_url
  end
  
  def index
    Visit.create(
				referer: request.headers["HTTP_REFERER"],
				article_id: 1000000,
				campaign_id: 1000000,
				plan_ids: ''
				)
    
    @lasttopstory = Article.notnotes.english.topstory.published.lastone
    @lastten = Article.notlatesttop.notupdate.notnotes.english.published.lastten
    @lasttennotes = Article.notes.english.published.lastten
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
				campaign_id: 1000001,
				plan_ids: ''
				)
    
    @lasttopstory = Article.notnotes.spanish.topstory.published.lastone
    @lastten = Article.notlatesttop.notupdate.notnotes.spanish.published.lastten
    @lasttennotes = Article.notes.spanish.published.lastten
    @rss = Article.all.spanish.order('created_at DESC')
    
    respond_to do |format|
      format.html
      format.rss { render :layout => false }
    end
  end
  
  def eng
    @rss = Article.all.english.order('created_at DESC')
    respond_to do |format|
      format.html
      format.rss { render :layout => false }
    end
  end
end
