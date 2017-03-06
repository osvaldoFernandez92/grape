class AddDownloadedToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :downloaded, :boolean, default: false
  end
end
