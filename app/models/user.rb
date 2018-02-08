class User < ApplicationRecord
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
    end

    user
  end

  private

  def self.get_email(auth)
    auth.info.email || "#{auth.provider}-#{auth.uid}@example.com"
  end

end
