class ChangeToVideoTeaser < ActiveRecord::Migration[5.2]
  def change
    rename_column :articles, :extras_transcription_intro, :extras_video_teaser
    rename_column :articles, :extras_transcription_file, :extras_video_intro
  end
end
