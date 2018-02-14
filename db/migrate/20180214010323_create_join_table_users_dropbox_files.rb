class CreateJoinTableUsersDropboxFiles < ActiveRecord::Migration[5.1]
  def change
    create_join_table :users, :dropbox_files do |t|
      # t.index [:user_id, :dropbox_file_id]
      # t.index [:dropbox_file_id, :user_id]
    end
  end
end
