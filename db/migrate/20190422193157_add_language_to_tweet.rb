class AddLanguageToTweet < ActiveRecord::Migration[5.2]
  def change
    add_column :tweets, :language_id, :integer
  end
end
