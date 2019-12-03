class AddsEmailStuffToFrames < ActiveRecord::Migration[5.2]
  def change
    add_column :frames, :email_reader_header, :string
    add_column :frames, :email_reader_text, :string
    add_column :frames, :email_reader_placeholder, :string
    add_column :frames, :email_reader_button, :string
  end
end
