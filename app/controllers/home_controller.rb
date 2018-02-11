class HomeController < ApplicationController
  before_action :set_user, :set_user_id, :authenticate_user!

  def index
    all_users = User.all
    @users = all_users.without(@user)
    @user_friends = @user.friends
    @requested_friends = @user.requested_friends
    @pending_friends = @user.pending_friends
  end

  def friend_request
    friend = User.find(@id)
    @user.friend_request(friend)

    respond_to do |format|
      format.js
    end
  end

  def accept_friend_request
    friend = User.find(@id)

    if params[:value] == 'accept'
      @user.accept_request(friend)
    else
      @user.decline_request(friend)
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

end
