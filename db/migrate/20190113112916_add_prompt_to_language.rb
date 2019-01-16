class AddPromptToLanguage < ActiveRecord::Migration[5.2]
	def change
		add_column :languages, :prompt, :string
	end
end