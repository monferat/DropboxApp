class DropboxController < ApplicationController
  before_action :authenticate_user!

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
  end

  def files_list
    @user_data_files = current_user.dropbox_files

    # @user_data_files.each do |f|
    #   f.singleton_class.instance_eval { attr_accessor :link }
    #   f.link = get_download_link(f.fid, f.owner_id)
    # end
  end

  def share_file
    unless params[:friend_id].empty?
      @file_id = params[:share_file_id]

      friend = User.find(params[:friend_id])
      common_file = DropboxFile.find(@file_id)

      if friend.dropbox_files.include? common_file
        @msg = 'Already shared'
      else
        friend.dropbox_files << common_file
        @msg = 'Shared'
      end
      respond_to { |format| format.js }
    end
  end

  def download_client_file
    data_file = get_dropbox_file(params[:file_id], params[:owner_id])
    file_path = "#{Rails.root}/public/#{data_file.name}"

    file = File.open(file_path, "w+b")
    unless data_file.nil?
      @client.download data_file.path_lower do
        |content| file.write content
      end
      file.close
      send_file file_path, disposition: 'attachment'
    end
  end

  def share_file_link
    @client = set_client
    share_file_links = @client.list_shared_links
    share_link = share_file_links.links.find{ |f| f.id == params[:file_id] }
    if share_link.nil?
      @user_folders = get_client_files(params[:owner_id])
      data_file = @user_folders.find { |f| f.id == params[:file_id] }
      share_link = @client.create_shared_link_with_settings data_file.path_lower
    end
    redirect_to share_link.url
  end

  private

  def get_download_link(file_id, owner_id)
    data_file = get_dropbox_file(file_id, owner_id)
    unless data_file.nil?
      file_link = @client.get_temporary_link(data_file.path_lower)
      file_link.link
    end
  end

  def get_dropbox_file(file_id, owner_id)
    @client = set_client
    @user_folders = get_client_files(owner_id)
    data_file = @user_folders.find { |f| f.id == file_id }
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
