class ChangeInvoiceStatusToBoolean < ActiveRecord::Migration[5.2]
  def change
    change_column :invoices, :invoice_status, :boolean
  end
end
