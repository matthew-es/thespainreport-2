class AddStoriesToArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles_stories, id: false do |t|
      t.integer :article_id
      t.integer :story_id
    end
  end
end
