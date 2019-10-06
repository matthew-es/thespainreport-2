class CreateCountries < ActiveRecord::Migration[5.2]
  def change
    create_table :countries do |t|
      t.string :country_code
      t.string :name_en
      t.string :name_es
      
      t.timestamps
    end
  end
end
