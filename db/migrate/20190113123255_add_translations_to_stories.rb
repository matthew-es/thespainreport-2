class AddTranslationsToStories < ActiveRecord::Migration[5.2]
  def change
    add_reference :stories, :original
  end
end
