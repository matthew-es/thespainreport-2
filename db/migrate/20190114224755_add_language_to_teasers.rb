class AddLanguageToTeasers < ActiveRecord::Migration[5.2]
  def change
    add_reference :teasers, :language
  end
end
