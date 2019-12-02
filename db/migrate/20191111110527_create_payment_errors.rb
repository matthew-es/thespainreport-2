class CreatePaymentErrors < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_errors do |t|
      t.integer :payment_id
      t.string :payment_error

      t.timestamps
    end
  end
end
