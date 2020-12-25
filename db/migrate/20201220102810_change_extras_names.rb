class ChangeExtrasNames < ActiveRecord::Migration[5.2]
  def change
    rename_column :articles, :extras_video, :extras_video_title
    rename_column :articles, :extras_video_intro, :extras_videos
    rename_column :articles, :extras_video_teaser, :extras_video_intro
  end
end
