class AddSourceToPaymentErrors < ActiveRecord::Migration[5.2]
  def change
    add_column :payment_errors, :error_source, :string
  end
end
