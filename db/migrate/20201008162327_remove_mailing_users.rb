class RemoveMailingUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :mailing_address
  end
end
