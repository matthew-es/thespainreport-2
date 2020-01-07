class ChangeAudioFields < ActiveRecord::Migration[5.2]
  def change
    rename_column :articles, :audio_file_length, :audio_file_mp3_length
    rename_column :articles, :audio_file_type, :audio_file_mp3_type
    add_column :articles, :audio_file_aac_length, :integer
    add_column :articles, :audio_file_aac_type, :string
  end
end
