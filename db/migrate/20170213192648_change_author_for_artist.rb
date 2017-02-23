class ChangeAuthorForArtist < ActiveRecord::Migration
  def change
  	rename_column :songs, :author, :artist
  end
end
