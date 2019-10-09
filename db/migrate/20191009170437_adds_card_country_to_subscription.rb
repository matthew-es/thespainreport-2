class AddsCardCountryToSubscription < ActiveRecord::Migration[5.2]
  def change
    add_column :subscriptions, :stripe_payment_method_card_country, :string
  end
end
