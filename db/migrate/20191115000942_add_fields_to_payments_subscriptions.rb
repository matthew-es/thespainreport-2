class AddFieldsToPaymentsSubscriptions < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :stripe_payment_method_expiry_reminder, :datetime
    add_column :subscriptions, :next_payment_date, :datetime
    add_column :subscriptions, :last_payment_date, :datetime
  end
end
