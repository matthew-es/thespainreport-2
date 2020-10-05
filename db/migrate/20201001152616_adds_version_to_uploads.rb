class AddsVersionToUploads < ActiveRecord::Migration[5.2]
  def change
    add_column :uploads, :version, :integer
  end
end
