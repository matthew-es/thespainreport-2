class AddDetailsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :stripe_customer_id, :string
    add_column :accounts, :stripe_payment_method, :string
  end
end
