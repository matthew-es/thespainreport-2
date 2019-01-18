class AddBitsToCampaigns < ActiveRecord::Migration[5.2]
  def change
    add_column :campaigns, :deal, :text
    add_column :campaigns, :social, :text
    add_column :campaigns, :riskreversal, :text
  end
end