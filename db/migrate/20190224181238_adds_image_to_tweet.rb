class AddsImageToTweet < ActiveRecord::Migration[5.2]
  def change
    add_column :tweets, :image, :string
  end
end
