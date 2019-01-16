class RemovesEsFromTypes < ActiveRecord::Migration[5.2]
  def change
    remove_column :types, :es
  end
end
