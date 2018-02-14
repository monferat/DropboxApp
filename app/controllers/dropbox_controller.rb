class DropboxController < ApplicationController
  before_action :set_client, only: [:files_list, :download]

  def index; end

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
    client = DropboxApi::Client.new(token)

    @folders = client.list_folder '/folder_13'
  end

  def files_list

    all_folders = @client.list_folder "/folder_#{current_user.id}"
    @user_folders = all_folders.entries

    @h = Hash.new
    @user_folders.each do |f|
      file_link = @client.get_temporary_link(f.path_lower)
      @h[f.name] = file_link.to_s
    end

    # @links = @client.get_temporary_link "/folder_13/glauber_2d.cpp"
  end

  private

  def set_client
    @client = DropboxApi::Client.new(ENV['DROPBOX_OAUTH_BEARER'])
  end

  def authenticator
    client_id = ENV['DROPBOX_CLIENT_ID']
    client_secret = ENV['DROPBOX_CLIENT_SECRET']

    DropboxApi::Authenticator.new(client_id, client_secret)
  end

  def redirect_uri
    dropbox_auth_callback_url # => http://localhost:3000/dropbox/auth_callback
  end
end
