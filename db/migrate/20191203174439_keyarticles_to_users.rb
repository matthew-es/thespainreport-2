class KeyarticlesToUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :bookmarks do |t|
      t.integer :article_id
      t.integer :user_id
      t.boolean :new_email_reader_article
      t.boolean :first_subscription_article
 
      t.timestamps
    end
  end
end