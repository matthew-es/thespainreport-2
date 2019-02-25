class AddPreviousToTweet < ActiveRecord::Migration[5.2]
  def change
    add_reference :tweets, :previous
  end
end
