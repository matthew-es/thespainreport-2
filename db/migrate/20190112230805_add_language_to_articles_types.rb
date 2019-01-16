class AddLanguageToArticlesTypes < ActiveRecord::Migration[5.2]
  def change
    add_reference :articles, :language
    add_reference :types, :language
  end
end
