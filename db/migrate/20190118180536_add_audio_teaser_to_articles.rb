class AddAudioTeaserToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :audioteaser, :string
  end
end
