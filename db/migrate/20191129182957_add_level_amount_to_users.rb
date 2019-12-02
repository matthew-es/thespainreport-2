class AddLevelAmountToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :level_amount, :integer
  end
end
