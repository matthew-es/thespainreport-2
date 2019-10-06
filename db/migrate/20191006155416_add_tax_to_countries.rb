class AddTaxToCountries < ActiveRecord::Migration[5.2]
  def change
    add_column :countries, :tax_percent, :decimal
  end
end
