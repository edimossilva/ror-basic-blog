class BlogsController < ApplicationController
  skip_before_action :authorize_request, only: %i[index show]
  before_action :public_request, only: %i[index show]

  def create
    blog = Blog.create!(create_params)
    render_created(blog)
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
    return render_ok(Blog.only_public) if @current_user.nil?

    render_ok(Blog.all)
  end

  def show
    blog = Blog.find_by!(id: search_params[:id])

    if BlogAccessLevel.can_show?(@current_user, blog)
      render_ok(blog.to_json(include: :posts))
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
