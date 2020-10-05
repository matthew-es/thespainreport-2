class UploadsArticleTable < ActiveRecord::Migration[5.2]
  def change
    create_table :photoessays do |t|
      t.references :article, index: true, foreign_key: true
      t.references :upload, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end