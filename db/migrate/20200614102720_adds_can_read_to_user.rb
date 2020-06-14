class AddsCanReadToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :can_read, :boolean
  end
end
