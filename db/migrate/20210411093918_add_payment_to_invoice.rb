class AddPaymentToInvoice < ActiveRecord::Migration[5.2]
  def change
    add_column :invoices, :payment_id, :integer
  end
end
