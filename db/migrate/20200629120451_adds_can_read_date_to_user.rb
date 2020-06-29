class AddsCanReadDateToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :can_read_date, :datetime
  end
end
