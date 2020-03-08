class BlogsController < ApplicationController
  skip_before_action :authorize_request, only: %i[index show]
  before_action :public_request, only: %i[index show]

  def create
    blog = Blog.new(create_params)

    if BlogAccessLevel.can_create?(@current_user, blog)
      blog.save!
      BlogNotificationService.on_blog_created(blog)
      render_created(BlogSerializer.new(blog))
    else
      render_unauthorized
    end
  end

  def destroy
    blog = Blog.find_by!(id: search_params[:id])

    if BlogAccessLevel.can_delete?(@current_user, blog)
      render_destroyed if blog.destroy!
    else
      render_unauthorized
    end
  end

  def index
    return render_ok(Blog.only_public.map { |blog| BlogSerializer.new(blog) }) if @current_user.nil?

    render_ok(Blog.all.map { |blog| BlogSerializer.new(blog) })
  end

  def show
    blog = Blog.find_by!(id: search_params[:id])

    if BlogAccessLevel.can_show?(@current_user, blog)
      render_ok(BlogSerializer.new(blog))
    else
      render_unauthorized
    end
  end

  private

  def create_params
    params.permit(:name, :is_private, :user_id)
  end

  def search_params
    params.permit(:id)
  end
end
