class AddVideoToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :video, :string
  end
end