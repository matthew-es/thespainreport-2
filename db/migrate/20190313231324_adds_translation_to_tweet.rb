class AddsTranslationToTweet < ActiveRecord::Migration[5.2]
  def change
    add_column :tweets, :quicktranslation, :string
  end
end
