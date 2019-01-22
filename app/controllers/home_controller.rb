class HomeController < ApplicationController
  def index
    @lasttopstory = Article.notnotes.english.topstory.published.lastone
    @lastten = Article.notlatesttop.notnotes.english.published.lastten
    @lasttennotes = Article.notes.english.published.lastten
  end
  
  def es
    @lasttopstory = Article.notnotes.spanish.topstory.published.lastone
    @lastten = Article.notlatesttop.notnotes.spanish.published.lastten
    @lasttennotes = Article.notes.spanish.published.lastten
  end
end
