class DefaultToWebhooks < ActiveRecord::Migration[5.2]
  def change
    change_column_default :webhook_events, :state, 0
  end
end
