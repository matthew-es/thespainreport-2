class CreateVisits < ActiveRecord::Migration[5.2]
  def change
    create_table :visits do |t|

      t.timestamps
    end
    
    add_column :visits, :article_id, :integer
    add_column :visits, :campaign_id, :integer
    add_column :visits, :plan_ids, :integer, array: true
    add_column :visits, :referer, :string
  end
end
