class ArticleSignUpChanges < ActiveRecord::Migration[5.2]
  def change
    remove_column :subscriptions, :article_id
    
    add_column :users, :article_from_server, :string
    rename_column :subscriptions, :referrer_url, :article_from_server
  end
end
