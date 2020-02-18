class MoreFramePatronMessages < ActiveRecord::Migration[5.2]
  def change
    rename_column :frames, :cta_patron_active, :cta_patron_active_bottom
    rename_column :frames, :access_patrons_below_25, :cta_patron_active_middle
    rename_column :frames, :access_patrons_above_25, :cta_patron_active_top
    
    remove_column :frames, :access_patrons_below_10
  end
end
