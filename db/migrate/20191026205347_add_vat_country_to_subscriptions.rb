class AddVatCountryToSubscriptions < ActiveRecord::Migration[5.2]
  def change
    add_column :subscriptions, :vat_country, :string
  end
end
