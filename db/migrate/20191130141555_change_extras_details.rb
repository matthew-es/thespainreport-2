class ChangeExtrasDetails < ActiveRecord::Migration[5.2]
  def change
    rename_column :articles, :extras_audio, :extras_audio_file
    rename_column :articles, :extras_teaser_audio, :extras_audio_teaser
    rename_column :articles, :extras_comment, :extras_notes
    rename_column :articles, :extras_teaser_comment, :extras_notes_teaser
    add_column :articles, :extras_transcription_teaser, :string
  end
end
