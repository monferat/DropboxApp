class HomeController < ApplicationController
  def index
    @users = User.all

    respond_to do |format|
      format.html
      format.js
    end
  end
end