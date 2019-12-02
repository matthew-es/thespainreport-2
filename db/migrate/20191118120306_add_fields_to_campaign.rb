class AddFieldsToCampaign < ActiveRecord::Migration[5.2]
  def change
    remove_column :campaigns, :deal
    rename_column :campaigns, :name, :emotional_quest_action
    rename_column :campaigns, :subtitle, :emotional_quest_role
    rename_column :campaigns, :teaser, :short_story
    rename_column :campaigns, :social, :social_proof
    rename_column :campaigns, :riskreversal, :risk_reversal
    rename_column :campaigns, :slug, :link_slug
    rename_column :campaigns, :buttontext, :button_cta
    add_column :campaigns, :money_word_singular, :string
    add_column :campaigns, :money_word_plural, :string
  end
end