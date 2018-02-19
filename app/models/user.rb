class User < ApplicationRecord
  has_friendship

  has_and_belongs_to_many :dropbox_files
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable


  def self.find_for_oauth(auth)
    user = User.where(uid: auth.uid, provider: auth.provider).first
    unless user
      user = User.create(
          uid: auth.uid,
          provider: auth.provider,
          token: auth.credentials.token,
          name: auth.info.name,
          email: User.get_email(auth),
          password: Devise.friendly_token[0, 20]
      )
      User.create_folder(user.id)
    end
    user
  end

  def self.create_folder(id)
    client = DropboxApi::Client.new(ENV['DROPBOX_OAUTH_BEARER'])
    client.create_folder "/folder_#{id}"
  end

  private

  def self.get_email(auth)
    auth.info.email || "#{auth.provider}-#{auth.uid}@example.com"
  end

end
