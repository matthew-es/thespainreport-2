class AddNfTvideotoarticle < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :nft_promo_video, :string
  end
end
