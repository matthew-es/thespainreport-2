class NewInvoiceStatusColumn < ActiveRecord::Migration[5.2]
  def change
    remove_column :invoices, :invoice_status
    add_column :invoices, :invoice_status, :boolean
  end
end
