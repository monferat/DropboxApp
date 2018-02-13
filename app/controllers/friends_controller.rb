class FriendsController < ApplicationController
  before_action :set_user, :set_user_id, :authenticate_user!

  def index
    all_users = User.all
    @users = all_users.without(@user)
    @user_friends = @user.friends
    @requested_friends = @user.requested_friends
    @pending_friends = @user.pending_friends
  end

  def friend_request
    @user.friend_request(get_friend)

    respond_to do |format|
      format.js
    end
  end

  def accept_friend_request

    if params[:value] == 'accept'
      @user.accept_request(get_friend)
    else
      @user.decline_request(get_friend)
    end

    respond_to do |format|
      format.html
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

  def get_friend
    User.find(@id)
  end

end
