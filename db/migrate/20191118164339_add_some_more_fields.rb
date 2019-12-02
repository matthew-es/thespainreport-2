class AddSomeMoreFields < ActiveRecord::Migration[5.2]
  def change
    add_column :campaigns, :money_word_verb, :string
    add_column :subscriptions, :campaign_money_word_singular, :string
    
    rename_column :subscriptions, :campaign_slug, :campaign_link_slug
    rename_column :subscriptions, :campaign_name, :campaign_emotional_quest_action
    rename_column :subscriptions, :campaign_buttontext, :campaign_button_cta
  end
end
