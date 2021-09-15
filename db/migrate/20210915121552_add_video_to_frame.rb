class AddVideoToFrame < ActiveRecord::Migration[5.2]
  def change
    add_column :frames, :video, :string
  end
end
