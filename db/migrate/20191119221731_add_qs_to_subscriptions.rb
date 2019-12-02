class AddQsToSubscriptions < ActiveRecord::Migration[5.2]
  def change
    add_column :subscriptions, :motivation_general_environment, :text
    add_column :subscriptions, :motivation_specific_brand, :text
  end
end
