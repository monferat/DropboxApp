module ApplicationHelper

  def check_friendship?(id)
    friend = User.find(id)
    current_user.friends_with?(friend)
  end

  def check_in_requested_list?(id)
    friend = User.find(id)
    friends = current_user.pending_friends
    friends.include?(friend)
  end
end
