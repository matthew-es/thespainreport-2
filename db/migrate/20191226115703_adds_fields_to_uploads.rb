class AddsFieldsToUploads < ActiveRecord::Migration[5.2]
  def change
    add_column :uploads, :file_size, :integer
    add_column :uploads, :file_type, :string
  end
end