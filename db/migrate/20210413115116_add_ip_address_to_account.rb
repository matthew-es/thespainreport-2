class AddIpAddressToAccount < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :ip_address, :string
  end
end
