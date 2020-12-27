class NewFieldsForFrames < ActiveRecord::Migration[5.2]
  def change
    rename_column :frames, :patron_10_25_message, :patron_10_24_message
rename_column :frames, :patron_10_25_linktext, :patron_10_24_linktext
add_column :frames, :patron_25_message, :string
add_column :frames, :patron_25_linktext, :string
  end
end
