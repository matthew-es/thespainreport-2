class AddObjectToPaymentErrors < ActiveRecord::Migration[5.2]
  def change
    add_column :payment_errors, :payment_error_object, :string
  end
end
