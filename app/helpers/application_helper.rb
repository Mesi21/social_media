# frozen_string_literal: true

module ApplicationHelper
  def friend_request_notifications(user)
    FriendRequest.where(friend: user).count
  end
end
