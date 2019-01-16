class AddsStatusToArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles_statuses, id: false do |t|
      t.integer :article_id
      t.integer :status_id
    end
  end
end
