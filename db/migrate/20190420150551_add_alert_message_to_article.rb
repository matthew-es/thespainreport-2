class AddAlertMessageToArticle < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :alertmessage, :string
  end
end
