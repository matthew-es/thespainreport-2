class AddNftToArticle < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :nft_number, :integer
    add_column :articles, :nft_address_creator, :string
    add_column :articles, :nft_address_contract, :string
    add_column :articles, :nft_blockchain, :string
    add_column :articles, :nft_token_type, :string
    add_column :articles, :nft_property_creator, :string
    add_column :articles, :nft_property_year, :string
    add_column :articles, :nft_property_place, :string
    add_column :articles, :nft_property_story_name, :string
    add_column :articles, :nft_property_story_position, :string
    add_column :articles, :nft_property_rarity, :string
    add_column :articles, :nft_link_opensea, :string
    add_column :articles, :nft_link_rarible, :string
  end
end