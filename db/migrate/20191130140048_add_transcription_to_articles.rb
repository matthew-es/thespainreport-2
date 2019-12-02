class AddTranscriptionToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :extras_transcription_file, :string
    add_column :articles, :extras_transcription_intro, :string
    rename_column :articles, :audio, :audio_file
  end
end
