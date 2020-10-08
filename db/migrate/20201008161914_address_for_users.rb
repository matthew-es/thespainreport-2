class AddressForUsers < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :country, :address
    add_column :users, :country_id, :integer
  end
end