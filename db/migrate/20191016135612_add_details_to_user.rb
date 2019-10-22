class AddDetailsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :country, :string
    add_column :users, :mailing_address, :string
  end
end
