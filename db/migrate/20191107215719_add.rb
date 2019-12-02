class Add < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :external_payment_error, :string
  end
end
