class Addsnamestoaddressesnfts < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :nft_address_creator_name, :string
    add_column :articles, :nft_address_contract_name, :string
  end
end
