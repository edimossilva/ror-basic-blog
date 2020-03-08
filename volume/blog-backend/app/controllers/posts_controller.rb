class PostsController < ApplicationController
  skip_before_action :authorize_request, only: [:show]
  before_action :public_request, only: [:show]

  def create
    post = Post.new(create_params)
    post.user_id = @current_user.id

    if PostAccessLevel.can_create?(@current_user, post)
      post.save!
      render_created(post)
    else
      render_unauthorized
    end
  end

  def destroy
    post = Post.find_by!(id: search_params[:id], blog_id: search_params[:blog_id])

    if PostAccessLevel.can_delete?(@current_user, post)
      post.destroy!

      PostNotificationService.on_post_deleted(post)
      render_destroyed
    else
      render_unauthorized
    end
  end

  def show
    post = Post.find_by!(id: search_params[:id], blog_id: search_params[:blog_id])

    if PostAccessLevel.can_show?(@current_user, post)
      render_ok(post)
    else
      render_unauthorized
    end
  end

  private

  def create_params
    params.permit(:title, :blog_id)
  end

  def search_params
    params.permit(:id, :blog_id)
  end
end
