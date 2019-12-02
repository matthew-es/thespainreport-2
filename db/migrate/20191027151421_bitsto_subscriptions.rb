class BitstoSubscriptions < ActiveRecord::Migration[5.2]
  def change
    add_column :subscriptions, :campaign_slug, :string
    add_column :subscriptions, :article_id, :integer
  end
end
