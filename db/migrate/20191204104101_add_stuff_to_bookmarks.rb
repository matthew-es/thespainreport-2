class AddStuffToBookmarks < ActiveRecord::Migration[5.2]
  def change
    add_column :bookmarks, :campaign_id, :integer
    add_column :bookmarks, :article_headline, :string
    add_column :bookmarks, :campaign_headline, :string
  end
end
