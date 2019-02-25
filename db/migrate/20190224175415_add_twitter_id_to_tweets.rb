class AddTwitterIdToTweets < ActiveRecord::Migration[5.2]
  def change
    add_column :tweets, :twitter_tweet_id, :integer
  end
end
