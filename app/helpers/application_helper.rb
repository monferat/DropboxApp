module ApplicationHelper

  def check_friendship?(id)
    friend = User.find(id)
    current_user.friends_with?(friend)
  end

end
