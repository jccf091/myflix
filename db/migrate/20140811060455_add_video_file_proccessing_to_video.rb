class AddVideoFileProccessingToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :video_file_processing, :boolean, default: true
  end
end
