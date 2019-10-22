class AddScaleToTaxPercent < ActiveRecord::Migration[5.2]
  def change
    change_column :countries, :tax_percent, :decimal, :precision => 5, :scale => 3
  end
end
