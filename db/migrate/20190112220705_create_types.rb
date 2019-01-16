class CreateTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :types do |t|
      t.string :eng
      t.string :es

      t.timestamps
    end
  end
end
