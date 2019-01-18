class AddPhotoToCampaign < ActiveRecord::Migration[5.2]
  def change
    add_column :campaigns, :image, :string
  end
end
