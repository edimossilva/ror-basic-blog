class BlogsController < ApplicationController
  before_action :authorize_request, :create

  def create
    blog = Blog.create(blog_params)
    if blog.valid?
      render json: blog, status: :created
    else
      render json: { error_message: I18n.t(".controllers.blogs.not_created"), errors: blog.errors }, status: :unprocessable_entity
    end
  end

  private 
  
  def blog_params
    params.permit(:name, :is_private, :user_id)
  end
end
