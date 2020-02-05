class AddLinksToFrame < ActiveRecord::Migration[5.2]
  def change
    add_column :frames, :emails_link_cta_readers, :string
  end
end