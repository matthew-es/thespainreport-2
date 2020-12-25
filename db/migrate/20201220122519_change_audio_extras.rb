class ChangeAudioExtras < ActiveRecord::Migration[5.2]
  def change
    rename_column :articles, :extras_audio_teaser, :extras_audio_title
		rename_column :articles, :extras_notes, :extras_audios
  end
end
