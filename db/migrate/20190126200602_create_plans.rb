class CreatePlans < ActiveRecord::Migration[5.2]
  def change
    create_table :plans do |t|

      t.timestamps
    end
    
    add_column :plans, :title, :string
    add_column :plans, :image, :string
    add_column :plans, :price, :integer
    add_column :plans, :description, :string
    add_column :plans, :buttontext, :string
    add_column :plans, :link, :string
  end
end
