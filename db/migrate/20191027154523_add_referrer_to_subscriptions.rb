class AddReferrerToSubscriptions < ActiveRecord::Migration[5.2]
  def change
    add_column :subscriptions, :referrer_url, :string
  end
end
