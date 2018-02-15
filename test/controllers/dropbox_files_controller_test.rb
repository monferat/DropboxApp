require 'test_helper'

class DropboxFilesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get dropbox_files_new_url
    assert_response :success
  end

  test "should get create" do
    get dropbox_files_create_url
    assert_response :success
  end

  test "should get destroy" do
    get dropbox_files_destroy_url
    assert_response :success
  end

end
