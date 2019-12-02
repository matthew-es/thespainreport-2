class CreateWebhookEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :webhook_events do |t|
      t.string :source
      t.string :external_id
      t.json :data
      t.integer :state
      t.text :processing_errors

      t.timestamps
    end
    add_index :webhook_events, :source
    add_index :webhook_events, :external_id
  end
end
