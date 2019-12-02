class ChangeAccountOwnerToUserId < ActiveRecord::Migration[5.2]
  def change
    rename_column :accounts, :account_owner, :user_id
  end
end
