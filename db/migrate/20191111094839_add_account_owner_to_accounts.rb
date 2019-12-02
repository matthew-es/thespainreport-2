class AddAccountOwnerToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :account_owner, :integer
  end
end
