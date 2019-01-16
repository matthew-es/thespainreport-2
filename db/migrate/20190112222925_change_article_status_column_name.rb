class ChangeArticleStatusColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :articles, :status, :status_id
  end
end
