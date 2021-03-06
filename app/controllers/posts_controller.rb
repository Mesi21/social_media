# frozen_string_literal: true

# Posts controller
class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :current_user, only: %i[create destroy]
  before_action :authorized?, only: %i[update destroy]
  before_action :set_friend_requests_count
  before_action :set_index_posts
  def index
    @posts = Post.paginate(page: params[:page], per_page: 5)
  end

  def show; end

  def new
    @post = Post.new
    # @comments = @post.comments
    # @comment = @post.commets.build
  end

  def edit; end

  def create
    @post = current_user.posts.build(post_params)
    respond_to do |format|
      if @post.save
        format.html { redirect_to authenticated_root_path, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { redirect_to current_user, alert: 'post not created' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def post_params
    params.require(:post).permit(:content, :picture)
  end

  def authorized?
    redirect_to :authenticated_root unless @post.user_id == current_user.id
  end

  def set_friend_requests_count
    @incoming_count = FriendRequest.where(friend: current_user).count
  end

  def set_index_posts
    @index_posts = current_user.friends_posts + current_user.posts
  end
end
