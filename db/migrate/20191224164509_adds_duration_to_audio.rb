class AddsDurationToAudio < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :audio_file_duration, :integer
  end
end
