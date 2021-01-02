class ChangesToFrames < ActiveRecord::Migration[5.2]
  def change
    rename_column :frames, :admin_linktext, :button_cta_trial_over
    rename_column :frames, :patron_payment_problem_linktext, :button_cta_increase
    
    remove_column :frames, :patron_payment_paused_linktext
    remove_column :frames, :patron_super_linktext
    remove_column :frames, :patron_25_linktext
    remove_column :frames, :patron_10_24_linktext
    remove_column :frames, :patron_5_9_linktext
    remove_column :frames, :patron_1_4_linktext
    remove_column :frames, :patron_0_linktext
    remove_column :frames, :reader_no_45_trial_linktext
    remove_column :frames, :reader_45_trial_linktext
  end
end