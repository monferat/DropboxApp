class HomeController < ApplicationController
  before_action :set_user, :authenticate_user!

  def index
  end

  def main_list
    @users = User.all

    respond_to do |format|
      format.html
      format.js
    end
  end

  def friends_list
    @user_friends = @user.friends

    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def set_user
    @user = current_user
  end

end