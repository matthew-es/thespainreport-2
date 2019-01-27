class AddLanguagesToPlans < ActiveRecord::Migration[5.2]
  def change
    add_reference :plans, :original
    add_reference :plans, :language
  end
end
