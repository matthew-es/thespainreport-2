class AddStuffToSubsriptions < ActiveRecord::Migration[5.2]
  def change
    rename_column :subscriptions, :amount, :plan_amount
    add_column :subscriptions, :vat_rate, :decimal
    add_column :subscriptions, :vat_amount, :integer
    add_column :subscriptions, :total_amount, :integer
    add_column :subscriptions, :campaign_id, :integer
  end
end
