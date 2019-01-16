class DropTeaserTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :teasers
  end
end
