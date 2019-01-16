class AddStoryToArticles < ActiveRecord::Migration[5.2]
  def change
    add_reference :articles, :story
  end
end
