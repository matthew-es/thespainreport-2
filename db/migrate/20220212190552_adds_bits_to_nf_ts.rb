class AddsBitsToNfTs < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :nft_original_price, :string
    add_column :articles, :nft_royalties, :string
  end
end