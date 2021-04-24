class RenamePaymentType < ActiveRecord::Migration[5.2]
  def change
    rename_column :payments, :type, :payment_type
  end
end
