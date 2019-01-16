class CreateCampaigns < ActiveRecord::Migration[5.2]
  def change
    create_table :campaigns do |t|
      t.text :teaser
      t.references :language, foreign_key: true

      t.timestamps
    end
  end
end
