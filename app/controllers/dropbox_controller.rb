class DropboxController < ApplicationController
  def index; end

  def folders_list
    @folders = @client_folders
  end

  # GET /dropbox/auth
  def auth
    url = authenticator.authorize_url redirect_uri: redirect_uri

    redirect_to url
  end

  # GET /dropbox/auth_callback?code=VofXA...
  def auth_callback
    auth_bearer = authenticator.get_token(params[:code],
                                          redirect_uri: redirect_uri)
    token = auth_bearer.token

    # Bound to the Dropbox account of your user.
    # If you persist this token, you can use it in subsequent requests or
    # background jobs to perform calls to Dropbox API such as the following.

    @client_folders = DropboxApi::Client.new(token).list_folder '/My_Folder'

    redirect_to dropbox_folders_path
  end

  private

  def authenticator
    client_id = ENV['DROPBOX_CLIENT_ID']
    client_secret = ENV['DROPBOX_CLIENT_SECRET']

    DropboxApi::Authenticator.new(client_id, client_secret)
  end

  def redirect_uri
    dropbox_auth_callback_url # => http://localhost:3000/dropbox/auth_callback
  end
end
