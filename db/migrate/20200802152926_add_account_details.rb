class AddAccountDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :invoices, :invoice_tax_country, :string
    add_column :accounts, :invoice_account_name, :string
    add_column :accounts, :invoice_account_address, :string
    add_column :accounts, :invoice_account_tax_id, :string
  end
end
