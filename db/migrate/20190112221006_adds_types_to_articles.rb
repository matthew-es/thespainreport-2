class AddsTypesToArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles_types, id: false do |t|
      t.integer :article_id
      t.integer :type_id
    end
  end
end