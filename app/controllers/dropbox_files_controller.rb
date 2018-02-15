class DropboxFilesController < ApplicationController
  before_action :authenticate_user!

  def new
    @dropbox_file = DropboxFile.new
  end

  def create
    @dropbox_file = DropboxFile.new(dropbox_file_params)
    @dropbox_file.name = @dropbox_file.attachment.identifier
    if @dropbox_file.save
      upload_file(@dropbox_file)
      redirect_to dropbox_files_list_path, notice: 'The file has been uploaded.'
    end
  end

  def destroy
    @dropbox_file = DropboxFile.find(params[:id])
    @dropbox_file.destroy
    redirect_to dropbox_files_list_path, notice: 'The file has been deleted.'
  end

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

    File.delete(dropbox_file.dropbox_file.attachment.current_path)
  end

  private

  def dropbox_file_params
    params.require(:dropbox_file).permit(:attachment)
  end
end
