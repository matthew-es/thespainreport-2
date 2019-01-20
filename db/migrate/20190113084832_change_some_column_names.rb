class ChangeSomeColumnNames < ActiveRecord::Migration[5.2]
  def change
    rename_column :types, :eng, :name
    rename_column :statuses, :eng, :name
  end
end
