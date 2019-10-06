class AddSlugToCampaigns < ActiveRecord::Migration[5.2]
  def change
    add_column :campaigns, :slug, :string
  end
end
