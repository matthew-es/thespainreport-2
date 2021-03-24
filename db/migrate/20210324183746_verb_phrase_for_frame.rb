class VerbPhraseForFrame < ActiveRecord::Migration[5.2]
  def change
    add_column :frames, :money_word_verb_phrase, :string
  end
end
