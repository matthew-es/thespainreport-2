class HomeController < ApplicationController
  def index
    @lasttopstory = Article.notnotes.english.topstory.published.lastone
    @lastten_english = Article.notlatesttop.notnotes.english.published.lastten
    @lastten_spanish = Article.notnotes.spanish.published.lastten
  end
end
