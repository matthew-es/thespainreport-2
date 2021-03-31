class AddsChangingEmailToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :changing_email_to, :string
  end
end
