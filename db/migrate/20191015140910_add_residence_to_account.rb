class AddResidenceToAccount < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :residence_country, :string
  end
end
