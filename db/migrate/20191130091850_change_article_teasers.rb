class ChangeArticleTeasers < ActiveRecord::Migration[5.2]
  def change
    rename_column :articles, :audioteaser, :audio_intro
    rename_column :articles, :extras_audioteaser, :extras_audio_intro
    rename_column :articles, :extras_body, :extras_comment
    rename_column :articles, :patrons_teaser, :extras_teaser_comment
    add_column :articles, :extras_teaser_audio, :string
    rename_column :articles, :is_free, :is_breaking
  end
end
