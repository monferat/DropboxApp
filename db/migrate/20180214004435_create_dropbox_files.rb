class CreateDropboxFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :dropbox_files do |t|
      t.string :name
      t.integer :owner_id

      t.timestamps
    end
  end
end
