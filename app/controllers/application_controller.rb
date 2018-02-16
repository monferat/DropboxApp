class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def set_client
    @client = DropboxApi::Client.new(ENV['DROPBOX_OAUTH_BEARER'])
  end

  def get_client_files(id)
    @client = set_client
    data_folders = @client.list_folder "/folder_#{id}"
    data_folders.entries
  end

end
