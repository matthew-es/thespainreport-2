class AddsColourChoicesToStatuses < ActiveRecord::Migration[5.2]
  def change
    add_column :statuses, :colorbackground, :string
    add_column :statuses, :colortext, :string
  end
end
