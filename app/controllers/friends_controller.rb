class FriendsController < ApplicationController
  before_action :set_user, :set_user_id, :authenticate_user!
  before_action :set_users, only: [:index]

  def index; end

  def show
    @tab = params[:tab_name]
    set_users if @tab == 'users'
    @user_friends = @user.friends if @tab == 'friends'
    @requested_friends = @user.requested_friends if @tab == 'requested_friends'
    @pending_friends = @user.pending_friends if @tab == 'pending_friends'

    respond_to do |format|
      format.js
    end
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

  def set_users
    all_users = User.all
    @users = all_users.without(@user)
  end

  def set_user
    @user = current_user
  end

  def set_user_id
    @id = params[:id] unless params[:id].nil?
  end

  def get_friend
    User.find(@id)
  end
end
