# frozen_string_literal: true

class FriendRequestsController < ApplicationController
  before_action :set_friend_request, except: %i[index create]
  before_action :set_friend_requests_count
  def index
    @friends = current_user.friends
    @incoming = FriendRequest.where(friend: current_user)
    @outgoing = current_user.friend_requests
  end

  def create
    friend = User.find(params[:friend_id])
    @friend_request = current_user.friend_requests.new(friend: friend)
    respond_to do |format|
      if @friend_request.save
        format.html { redirect_to users_path, notice: 'friend request created.' }
        format.json { render :show, status: :created, location: @friend_request }
      else
        format.html { redirect_to users_path, alert: 'friend request not created.' }
        format.json { render json: @friend_request.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      @friend_request.accept
      format.html { redirect_to users_path, notice: 'Friend Accepted.' }
      format.json { head :no_content }
    end
  end

  def destroy
    @friend_request.destroy
    respond_to do |format|
      format.html { redirect_to users_path, alert: 'Friend request deleted' }
      format.json { head :no_content }
    end
  end

  private

  def set_friend_request
    @friend_request = FriendRequest.find(params[:id])
  end

  def set_friend_requests_count
    @incoming_count = FriendRequest.where(friend: current_user).count
  end
end
