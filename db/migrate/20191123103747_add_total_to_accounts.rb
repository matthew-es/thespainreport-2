class AddTotalToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :total_support, :integer
  end
end
