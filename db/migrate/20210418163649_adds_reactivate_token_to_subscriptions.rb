class AddsReactivateTokenToSubscriptions < ActiveRecord::Migration[5.2]
  def change
    add_column :subscriptions, :reactivate_token, :string
  end
end
