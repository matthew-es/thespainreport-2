class AddConversationStatusToAccount < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :conversation_status, :integer
  end
end
