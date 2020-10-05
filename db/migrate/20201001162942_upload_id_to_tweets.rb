class UploadIdToTweets < ActiveRecord::Migration[5.2]
  def change
    add_column :tweets, :upload_id, :integer
  end
end
