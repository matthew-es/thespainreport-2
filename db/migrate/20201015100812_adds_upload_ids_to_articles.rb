class AddsUploadIdsToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :audio_aac_id, :integer
    add_column :articles, :audio_mp3_id, :integer
    add_column :articles, :extra_audio_aac_id, :integer
    add_column :articles, :extra_audio_mp3_id, :integer
  end
end
