class BlogAccessLevel
  def self.can_delete?(user, blog)
    return admin_can_delete?(user, blog) if user.admin?
    false
  end

  def self.can_show?(user, blog)
    return nonregistred_can_view?(user, blog) if user.nil?
    false
  end

  private

  def self.admin_can_delete?(user, blog)
    return true if blog.user_registred? 
    user.is_owner?(blog)
  end

  def self.nonregistred_can_view?(user, blog)
    return !blog.is_private? 
  end
end