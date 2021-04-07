class IpForAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :ip_country, :string
  end
end
