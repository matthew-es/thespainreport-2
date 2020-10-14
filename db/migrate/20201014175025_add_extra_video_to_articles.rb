class AddExtraVideoToArticles < ActiveRecord::Migration[5.2]
  def change
    rename_column :articles, :extras_transcription_teaser, :extras_video
  end
end
