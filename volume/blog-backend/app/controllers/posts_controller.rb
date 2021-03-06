class PostsController < ApplicationController
  skip_before_action :authorize_request, only: [:show]
  before_action :public_request, only: [:show]

  def create
    post = Post.new(create_params)
    post.user_id = @current_user.id

    authorize post

    post.save!

    render_created(PostSerializer.new(post))
  end

  def destroy
    post = Post.find_by!(id: search_params[:id], blog_id: search_params[:blog_id])

    authorize post

    post.destroy!

    PostNotificationService.on_post_deleted(post)

    render_destroyed
  end

  def show
    post = Post.find_by!(id: search_params[:id], blog_id: search_params[:blog_id])

    authorize post

    render_ok(PostSerializer.new(post))
  end

  private

  def create_params
    params.permit(:title, :blog_id)
  end

  def search_params
    params.permit(:id, :blog_id)
  end
end
