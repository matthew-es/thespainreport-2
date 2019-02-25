class AddsArticleToTweets < ActiveRecord::Migration[5.2]
  def change
    add_reference :tweets, :article
  end
end
