class AddButtonTextToCampaign < ActiveRecord::Migration[5.2]
  def change
    add_column :campaigns, :buttontext, :string
  end
end
