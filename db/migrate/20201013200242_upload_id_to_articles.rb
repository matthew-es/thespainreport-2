class UploadIdToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :upload_id, :integer
  end
end
