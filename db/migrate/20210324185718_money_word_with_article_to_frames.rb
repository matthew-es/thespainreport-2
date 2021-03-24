class MoneyWordWithArticleToFrames < ActiveRecord::Migration[5.2]
  def change
    add_column :frames, :money_word_with_article, :string
  end
end
