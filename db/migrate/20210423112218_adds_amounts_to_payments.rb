class AddsAmountsToPayments < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :base_amount, :integer
    add_column :payments, :vat_amount, :integer
  end
end
