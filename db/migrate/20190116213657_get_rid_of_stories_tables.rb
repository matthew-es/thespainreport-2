class GetRidOfStoriesTables < ActiveRecord::Migration[5.2]
  def change
    drop_table :stories
    drop_table :articles_stories
  end
end
