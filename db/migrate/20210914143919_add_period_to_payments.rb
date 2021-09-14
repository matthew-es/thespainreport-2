class AddPeriodToPayments < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :payment_period, :string
  end
end
