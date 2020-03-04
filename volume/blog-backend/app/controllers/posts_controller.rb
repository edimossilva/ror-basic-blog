class PostsController < ApplicationController
  def create
    post = Post.new(create_params)
    post.user_id = @current_user.id

    return render_unauthorized unless PostAccessLevel.can_create?(@current_user,post)

    if post.valid? 
      render json: post, status: :created
    else
      render json: { error_message: "Post not created", errors: post.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    post = Post.find_by(id: destroy_params[:id], blog_id:destroy_params[:blog_id])
    return render_not_found(Post, destroy_params) if (post.nil?)
    
    if (PostAccessLevel.can_delete?(@current_user, post))
      post.destroy!
      render_destroyed
    else
      render_unauthorized
    end
  end

  private 
  def create_params
    params.permit(:title, :blog_id)
  end

  def destroy_params
    params.permit(:id, :blog_id)
  end

  def show_params
    params.permit(:id, :blog_id)
  end
end