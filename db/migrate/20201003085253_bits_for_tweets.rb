class BitsForTweets < ActiveRecord::Migration[5.2]
  def change
    add_column :tweets, :tweet_url, :string
    remove_column :tweets, :language_id, :integer
  end
end
