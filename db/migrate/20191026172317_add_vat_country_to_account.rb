class AddVatCountryToAccount < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :vat_country, :string
  end
end
