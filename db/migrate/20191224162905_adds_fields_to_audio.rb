class AddsFieldsToAudio < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :audio_episode_notes, :text
    add_column :articles, :audio_file_length, :integer
    add_column :articles, :audio_file_type, :string
    add_column :articles, :audio_file_episode, :integer
  end
end