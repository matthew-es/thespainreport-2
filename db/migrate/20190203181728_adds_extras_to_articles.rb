class AddsExtrasToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :extras_audio, :string
    add_column :articles, :extras_audioteaser, :string
    add_column :articles, :extras_body, :text
  end
end
