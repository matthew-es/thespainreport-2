class AddsTranslationsToArticle < ActiveRecord::Migration[5.2]
  def change
    add_reference :articles, :original
  end
end
