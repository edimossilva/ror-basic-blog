class BlogAccessLevel
  def self.can_create?(user, blog)
    return logged_user_can_create?(user, blog) if user.has_access_level?
  end

  def self.can_delete?(user, blog)
    return admin_can_delete?(user, blog) if user.admin?

    false
  end

  def self.can_show?(user, blog)
    return nonregistred_can_view?(blog) if user.nil?

    true
  end

  def self.admin_can_delete?(user, blog)
    return true if blog.user_registred?

    user.is_owner?(blog)
  end

  def self.nonregistred_can_view?(blog)
    !blog.is_private?
  end

  def self.logged_user_can_create?(user, blog)
    user.is_owner?(blog)
  end
end
