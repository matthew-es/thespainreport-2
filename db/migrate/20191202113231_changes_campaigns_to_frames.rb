class ChangesCampaignsToFrames < ActiveRecord::Migration[5.2]
  def change
    rename_table :campaigns, :frames
    rename_column :articles, :campaign_id, :frame_id
    rename_column :subscriptions, :campaign_id, :frame_id
    rename_column :subscriptions, :campaign_link_slug, :frame_link_slug
    rename_column :subscriptions, :campaign_emotional_quest_action, :frame_emotional_quest_action
    rename_column :subscriptions, :campaign_button_cta, :frame_button_cta
    rename_column :subscriptions, :campaign_money_word_singular, :frame_money_word_singular
    rename_column :users, :campaign_id, :frame_id
    rename_column :visits, :campaign_id, :frame_id
  end
end
