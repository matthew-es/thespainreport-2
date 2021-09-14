class AddsPeriodToSubscription < ActiveRecord::Migration[5.2]
  def change
    add_column :subscriptions, :payment_period, :string
  end
end
