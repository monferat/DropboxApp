class HomeController < ApplicationController
  before_action :set_user, :set_user_id, :authenticate_user!

  def index
    @users = User.all
    @user_friends = @user.friends
    @requested_friends = @user.requested_friends
    @pending_friends = @user.pending_friends
  end

  def friend_request

    respond_to do |format|
      format.js
    end
  end

  private

  def set_user
    @user = current_user
  end

  def set_user_id
    unless params[:id].nil?
      @id = params[:id]
    end
  end

end
