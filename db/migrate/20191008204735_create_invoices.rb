class CreateInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :invoices do |t|
      t.decimal :tax_percent
      t.integer :plan_amount
      t.integer :tax_amount
      t.integer :total_amount
      t.integer :account_id
      t.integer :subscription_id

      t.timestamps
    end
  end
end
