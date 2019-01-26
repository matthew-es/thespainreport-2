class HomeController < ApplicationController
  def index
    @lasttopstory = Article.notnotes.english.topstory.published.lastone
    @lastten = Article.notlatesttop.notnotes.english.published.lastten
    @lasttennotes = Article.notes.english.published.lastten
    @rss = Article.all.order('created_at DESC')
    respond_to do |format|
      format.html
      format.rss { render :layout => false }
    end
  end
  
  def es
    @lasttopstory = Article.notnotes.spanish.topstory.published.lastone
    @lastten = Article.notlatesttop.notnotes.spanish.published.lastten
    @lasttennotes = Article.notes.spanish.published.lastten
    @rss = Article.all.spanish.order('created_at DESC')
    respond_to do |format|
      format.html
      format.rss { render :layout => false }
    end
  end
end
