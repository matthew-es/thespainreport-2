class AddFromDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :invoices, :invoice_from_name, :string
    add_column :invoices, :invoice_from_address, :string
    add_column :invoices, :invoice_from_tax_id, :string
  end
end
