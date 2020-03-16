class BlogPolicy
  attr_reader :user, :blog

  def initialize(user, blog)
    @user = user
    @blog = blog
  end

  def show?
    user&.has_access_level? || blog.public?
  end

  def destroy?
    return admin_can_delete?(user, blog) if user.admin?

    false
  end

  private
  def admin_can_delete?(user, blog)
    return true if blog.user_registred?

    user.is_owner?(blog)
  end
end