class AddTypesToInvoices < ActiveRecord::Migration[5.2]
  def change
    add_column :invoices, :invoice_type, :string
    add_column :invoices, :invoice_operation, :string
  end
end
