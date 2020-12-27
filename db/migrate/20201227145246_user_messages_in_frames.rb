class UserMessagesInFrames < ActiveRecord::Migration[5.2]
  def change
    add_column :frames, :admin_message, :string
add_column :frames, :patron_0_message, :string
add_column :frames, :reader_45_trial_message, :string
add_column :frames, :reader_no_45_trial_message, :string
add_column :frames, :admin_linktext, :string
add_column :frames, :patron_0_linktext, :string
add_column :frames, :reader_45_trial_linktext, :string
add_column :frames, :reader_no_45_trial_linktext, :string
rename_column :frames, :cta_reader_to_patron, :patron_1_4_message
rename_column :frames, :cta_patron_active_bottom, :patron_5_9_message
rename_column :frames, :cta_patron_active_middle, :patron_10_25_message
rename_column :frames, :cta_patron_active_top, :patron_super_message
rename_column :frames, :cta_patron_paused, :patron_payment_paused_message
rename_column :frames, :cta_patron_cancelled, :patron_payment_problem_message
rename_column :frames, :cta_reader_to_patron_link, :patron_1_4_linktext
rename_column :frames, :cta_patron_active_bottom_link, :patron_5_9_linktext
rename_column :frames, :cta_patron_active_middle_link, :patron_10_25_linktext
rename_column :frames, :cta_patron_active_top_link, :patron_super_linktext
rename_column :frames, :cta_patron_paused_link, :patron_payment_paused_linktext
rename_column :frames, :cta_patron_cancelled_link, :patron_payment_problem_linktext
  end
end
