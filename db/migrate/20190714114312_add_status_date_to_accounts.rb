class AddStatusDateToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :account_status_date, :datetime
  end
end
