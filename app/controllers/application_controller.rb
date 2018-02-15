class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def set_client
    DropboxApi::Client.new(ENV['DROPBOX_OAUTH_BEARER'])
  end
end
