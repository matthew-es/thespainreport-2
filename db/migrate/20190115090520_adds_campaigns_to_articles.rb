class AddsCampaignsToArticles < ActiveRecord::Migration[5.2]
  def change
    add_reference :articles, :campaign
    
    add_column :campaigns, :name, :string
    add_reference :campaigns, :original
  end
end