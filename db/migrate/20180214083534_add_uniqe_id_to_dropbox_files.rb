class AddUniqeIdToDropboxFiles < ActiveRecord::Migration[5.1]
  def change
    add_column :dropbox_files, :fid, :string
  end
end
