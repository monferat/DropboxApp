class AddAttachmentToDropboxFiles < ActiveRecord::Migration[5.1]
  def change
    add_column :dropbox_files, :attachment, :string
  end
end
