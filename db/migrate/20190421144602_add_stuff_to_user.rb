class AddStuffToUser < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :role, 'integer USING CAST(role AS integer)'
    add_column :users, :emails, :integer
    add_column :users, :emaillanguage, :integer
    add_column :users, :sitelanguage, :integer
  end
end
