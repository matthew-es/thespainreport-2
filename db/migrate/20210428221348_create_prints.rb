class CreatePrints < ActiveRecord::Migration[5.2]
  def change
    create_table :prints do |t|
      t.belongs_to :user
      t.belongs_to :upload
      t.datetime :order_date
      t.timestamps
    end
  end
end
