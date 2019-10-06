class AddSubToCampaigns < ActiveRecord::Migration[5.2]
  def change
    add_column :campaigns, :subtitle, :string
  end
end