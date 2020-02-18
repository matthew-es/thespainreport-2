class RemoveColumnFromFrames < ActiveRecord::Migration[5.2]
  def change
    remove_column :frames, :access_readers_to_patrons
  end
end
