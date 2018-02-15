class DropboxFile < ApplicationRecord
  has_and_belongs_to_many :users

  mount_uploader :attachment, AttachmentUploader
end
