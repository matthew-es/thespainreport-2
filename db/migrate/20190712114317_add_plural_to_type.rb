class AddPluralToType < ActiveRecord::Migration[5.2]
  def change
    add_column :types, :name_plural, :string
  end
end
