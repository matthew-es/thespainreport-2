class ChangeTeaserColumnType < ActiveRecord::Migration[5.2]
  def change
    change_column :teasers, :text, :text
  end
end
