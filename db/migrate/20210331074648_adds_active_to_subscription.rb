class AddsActiveToSubscription < ActiveRecord::Migration[5.2]
  def change
    add_column :subscriptions, :is_active, :boolean
  end
end
