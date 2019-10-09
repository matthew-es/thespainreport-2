class AddsCardCountryToAccount < ActiveRecord::Migration[5.2]
  def change
    remove_column :subscriptions, :stripe_payment_method_card_country, :string
    add_column :accounts, :stripe_payment_method_card_country, :string
  end
end
