class AddsFieldsToPayments < ActiveRecord::Migration[5.2]
  def change
   add_column :payments, :card_country, :string
   add_column :payments, :total_amount, :integer
   add_column :payments, :account_id, :integer
   add_column :payments, :invoice_id, :integer
   add_column :payments, :subscription_id, :integer
   add_column :payments, :payment_method, :string
  end
end
