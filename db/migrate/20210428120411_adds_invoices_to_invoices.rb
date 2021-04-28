class AddsInvoicesToInvoices < ActiveRecord::Migration[5.2]
  def change
    add_column :invoices, :original_id, :integer
  end
end
