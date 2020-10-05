class AddNumberToInvoice < ActiveRecord::Migration[5.2]
  def change
    add_column :invoices, :invoice_number, :string
  end
end
