class AddFieldsToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :type_id, :integer
    add_column :articles, :status, :integer
    add_column :articles, :topstory, :boolean
    add_column :articles, :is_free, :boolean
  end
end
