class DropPhotoEssayTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :photoessays
  end
end
