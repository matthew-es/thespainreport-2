class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.integer :account_id
      t.integer :amount
      t.string :card_country
      t.datetime :latest_paid_date
      t.string :ip_country
      t.string :ip_address
      t.string :residence_country

      t.timestamps
    end
  end
end
