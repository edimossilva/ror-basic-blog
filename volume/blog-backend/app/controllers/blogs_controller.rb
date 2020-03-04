class BlogsController < ApplicationController
  skip_before_action :authorize_request, only: [:show]
  before_action :public_request, only: [:show]

  def create
    blog = Blog.create(create_params)
    if blog.valid?
      render json: blog, status: :created
    else
      render json: { error_message: I18n.t(".controllers.blogs.not_created"), errors: blog.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    blog = Blog.find_by(id: destroy_params[:id])
    return render_not_found(Blog, destroy_params) if (blog.nil?)
    
    if (BlogAccessLevel.can_delete?(@current_user, blog))
      blog.destroy!
      render_destroyed
    else
      render_unauthorized
    end
  end

  def show
    blog = Blog.find_by(id: show_params[:id])
    return render_not_found(Blog, show_params) if (blog.nil?)
    
    if (BlogAccessLevel.can_show?(@current_user, blog))
      render_ok(blog)
    else
      render_unauthorized
    end
  end

  private 
  
  def create_params
    params.permit(:name, :is_private, :user_id)
  end

  def destroy_params
    params.permit(:id)
  end

  def show_params
    params.permit(:id)
  end
end
