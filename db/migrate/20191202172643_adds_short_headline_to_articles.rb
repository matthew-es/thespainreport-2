class AddsShortHeadlineToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :short_headline, :string
  end
end
