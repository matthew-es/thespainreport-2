class AddBitsToSubscriptions < ActiveRecord::Migration[5.2]
  def change
    add_column :subscriptions, :campaign_name, :string
    add_column :subscriptions, :campaign_buttontext, :string
  end
end
