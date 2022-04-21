class ChangesBreakingToPremium < ActiveRecord::Migration[5.2]
  def change
    rename_column :articles, :is_breaking, :premium
  end
end
