class BlogPolicy
  attr_reader :user, :blog

  def initialize(user, blog)
    @user = user
    @blog = blog
  end

  def create?
    user.owner?(blog)
  end

  def destroy?
    return admin_can_delete?(user, blog) if user.admin?

    false
  end

  def show?
    user&.access_level? || blog.public?
  end

  private

  def admin_can_delete?(user, blog)
    return true if blog.user_registred?

    user.owner?(blog)
  end
end
