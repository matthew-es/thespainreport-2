class ExtrasColumnsForFrames < ActiveRecord::Migration[5.2]
  def change
    add_column :frames, :patrons_extra_videos, :string
    add_column :frames, :patrons_extra_audios, :string
    add_column :frames, :patrons_extra_photos, :string
    add_column :frames, :patrons_extra_column, :string
  end
end
