class RenameFrameThings < ActiveRecord::Migration[5.2]
  def change
    rename_column :bookmarks, :campaign_id, :frame_id
    rename_column :bookmarks, :campaign_headline, :frame_emotional_quest_action
  end
end
