class AddBitsToInvoices < ActiveRecord::Migration[5.2]
  def change
    add_column :invoices, :invoice_year, :integer
    add_column :invoices, :invoice_month, :integer
    add_column :invoices, :invoice_day, :integer
  end
end
