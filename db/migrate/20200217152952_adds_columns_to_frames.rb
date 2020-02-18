class AddsColumnsToFrames < ActiveRecord::Migration[5.2]
  def change
    add_column :frames, :cta_reader_to_patron_link, :string
    add_column :frames, :cta_patron_active_bottom_link, :string
    add_column :frames, :cta_patron_active_middle_link, :string
    add_column :frames, :cta_patron_active_top_link, :string
    add_column :frames, :cta_patron_paused_link, :string
    add_column :frames, :cta_patron_cancelled_link, :string
  end
end
