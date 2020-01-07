class AddAacToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :audio_file_aac, :string
    rename_column :articles, :audio_file, :audio_file_mp3
  end
end
