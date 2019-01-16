class AddUpdatesToArticles < ActiveRecord::Migration[5.2]
  def change
    add_reference :articles, :main
  end
end
