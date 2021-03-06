# frozen_string_literal: true

class FriendsController < ApplicationController
  before_action :set_friend, only: :destroy
  before_action :set_friend_requests_count
  def index
    @friends = current_user.friends
  end

  def destroy
    current_user.remove_friend(current_user, @friend)
    respond_to do |format|
      format.html { redirect_to current_user, notice: 'Friend removed' }
      format.json { head :no_content }
    end
  end

  private

  def set_friend
    @friend = current_user.friends.find(params[:id])
  end

  def set_friend_requests_count
    @incoming_count = FriendRequest.where(friend: current_user).count
  end
end
