class AddPatronsTeaserToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :patrons_teaser, :string
  end
end
