class AddaccountroletoUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :account_role, :integer
  end
end
