class AddExternalsToPayments < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :external_payment_id, :string
    add_column :payments, :external_payment_status, :string
  end
end
