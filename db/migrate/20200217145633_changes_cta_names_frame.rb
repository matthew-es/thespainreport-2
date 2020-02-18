class ChangesCtaNamesFrame < ActiveRecord::Migration[5.2]
  def change
    rename_column :frames, :emails_link_cta_readers, :cta_reader_to_patron
    rename_column :frames, :emails_link_thanks_patrons, :cta_patron_active
    rename_column :frames, :emails_link_thanks_patrons_paused, :cta_patron_paused
    rename_column :frames, :emails_link_thanks_patrons_cancelled, :cta_patron_cancelled
  end
end
