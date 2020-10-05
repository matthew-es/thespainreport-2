class AddStatusToInvoice < ActiveRecord::Migration[5.2]
  def change
    add_column :invoices, :invoice_status, :integer
  end
end
