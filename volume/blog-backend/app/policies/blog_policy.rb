class BlogPolicy
  attr_reader :user, :blog

  def initialize(user, blog)
    @user = user
    @blog = blog
  end

  def show?
    user&.has_access_level? || blog.public?
  end
end