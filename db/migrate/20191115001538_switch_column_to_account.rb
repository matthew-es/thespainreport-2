class SwitchColumnToAccount < ActiveRecord::Migration[5.2]
  def change
    remove_column :payments, :stripe_payment_method_expiry_reminder, :datetime
    add_column :accounts, :stripe_payment_method_expiry_reminder, :datetime
  end
end
