class AddSearchIndexToVideos < ActiveRecord::Migration
  def up
    execute "create index videos_title on videos using gin(to_tsvector('english', title))"
    execute "create index videos_description on videos using gin(to_tsvector('english',description))"
  end

  def down
    execute "drop index videos_title"
    execute "drop index videos_description"
  end
end
