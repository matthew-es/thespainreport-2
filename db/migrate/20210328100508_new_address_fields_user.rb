class NewAddressFieldsUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :address_name, :string
    rename_column :users, :address, :address_street
    add_column :users, :address_postcode, :string
    add_column :users, :address_country, :string
  end
end
