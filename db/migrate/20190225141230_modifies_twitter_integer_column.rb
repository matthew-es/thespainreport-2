class ModifiesTwitterIntegerColumn < ActiveRecord::Migration[5.2]
  def change
    change_column :tweets, :twitter_tweet_id, :integer, :limit => 8
  end
end
