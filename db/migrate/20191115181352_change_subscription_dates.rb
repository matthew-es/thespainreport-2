class ChangeSubscriptionDates < ActiveRecord::Migration[5.2]
  def change
    remove_column :subscriptions, :last_payment_date, :datetime
    rename_column :subscriptions, :latest_paid_date, :last_payment_date
  end
end
