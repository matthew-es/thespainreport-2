class ChangeUserRole < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :role, :status
  end
end
