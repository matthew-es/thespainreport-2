class HomeController < ApplicationController
  def index
    @lasttopstory = Article.topstory.published.lastone
    @lastten = Article.published.lastten
  end
end
