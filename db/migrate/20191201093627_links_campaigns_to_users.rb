class LinksCampaignsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :campaign_id, :integer
    add_column :campaigns, :access_patrons_only, :string
    add_column :campaigns, :access_more_for_patrons, :string
    add_column :campaigns, :access_readers_to_patrons, :string
    add_column :campaigns, :access_patrons_below_10, :string
    add_column :campaigns, :access_patrons_below_25, :string
    add_column :campaigns, :access_patrons_above_25, :string
  end
end