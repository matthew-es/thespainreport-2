class AddLanguageToStories < ActiveRecord::Migration[5.2]
  def change
    add_reference :stories, :language
  end
end
