class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email
      t.boolean :email_confirmed
      t.string :password_digest
      t.string :role
      t.string :confirm_token

      t.timestamps
    end
  end
end
