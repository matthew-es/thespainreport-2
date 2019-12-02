class AddFieldsToPaymentErrors < ActiveRecord::Migration[5.2]
  def change
    add_column :payment_errors, :payment_error_status, :string
    add_column :payment_errors, :payment_error_code, :string
    rename_column :payment_errors, :payment_error, :payment_error_message
    rename_column :payment_errors, :error_source, :payment_error_source
  end
end