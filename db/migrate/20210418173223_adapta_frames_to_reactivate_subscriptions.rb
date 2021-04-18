class AdaptaFramesToReactivateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    rename_column :frames, :patron_0_message, :patron_paused_message
    add_column :frames, :button_cta_reactivate, :string
  end
end
