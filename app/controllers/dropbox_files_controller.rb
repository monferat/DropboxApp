class DropboxFilesController < ApplicationController
  before_action :authenticate_user!

  def new
    @dropbox_file = DropboxFile.new
  end

  def create
    if params[:attachment]
      @dropbox_file = DropboxFile.new(dropbox_file_params)
      @dropbox_file.name = @dropbox_file.attachment.identifier
      if @dropbox_file.save
        upload_file(@dropbox_file)
        redirect_to dropbox_files_list_path, notice: 'The file has been uploaded.'
      end
    else
      redirect_to new_dropbox_file_path, notice: 'No file selected.'
    end
  end

  def destroy
    @dropbox_file = DropboxFile.find(params[:id])
    if @dropbox_file.owner_id == current_user.id
      delete_from_dropbox(@dropbox_file)
      @dropbox_file.destroy
      redirect_to dropbox_files_list_path, notice: 'The file has been deleted.'
    else
      redirect_to dropbox_files_list_path, notice: 'You are not file owner'
    end
  end

  private

  # Upload to dropbox
  def upload_file(dropbox_file)
    @client = set_client

    dropbox_file.owner_id = current_user.id
    current_user.dropbox_files << dropbox_file

    # send file to Dropbox clients folder
    file_content = IO.read dropbox_file.attachment.current_path
    data_file = @client.upload "/folder_#{current_user.id}/#{dropbox_file.name}", file_content

    # save unique file id from Dropbox
    dropbox_file.fid = data_file.id
    dropbox_file.save

    File.delete(dropbox_file.attachment.current_path)
  end

  def delete_from_dropbox(client_file)
    client_files = get_client_files(client_file.owner_id)
    @client = set_client
    data_file = client_files.find { |f| f.id == client_file.fid }
    @client.delete(data_file.path_lower) unless data_file.nil?
  end

  def dropbox_file_params
    params.require(:dropbox_file).permit(:attachment)
  end
end
