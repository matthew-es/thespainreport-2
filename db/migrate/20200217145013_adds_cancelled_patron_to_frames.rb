class AddsCancelledPatronToFrames < ActiveRecord::Migration[5.2]
  def change
    add_column :frames, :emails_link_thanks_patrons_cancelled, :string
  end
end
