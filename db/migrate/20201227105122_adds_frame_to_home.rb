class AddsFrameToHome < ActiveRecord::Migration[5.2]
  def change
    add_column :frames, :patrons_extra_home, :string
  end
end
