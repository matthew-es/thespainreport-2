class AddsTypeToPayments < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :type, :string
  end
end
