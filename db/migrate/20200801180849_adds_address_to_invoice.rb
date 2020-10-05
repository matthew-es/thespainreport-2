class AddsAddressToInvoice < ActiveRecord::Migration[5.2]
  def change
    add_column :invoices, :invoice_customer_address, :string
    add_column :invoices, :invoice_customer_tax_id, :string
    add_column :invoices, :invoice_customer_name, :string
  end
end
