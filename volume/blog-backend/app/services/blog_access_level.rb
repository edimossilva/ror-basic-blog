class BlogAccessLevel
  def self.can_delete?(user, blog)
    return admin_can_delete?(user, blog) if user.admin?
    false
  end

  private

  def self.admin_can_delete?(user, blog)
    return true if blog.user_registred? 
    user.is_owner?(blog)
  end
end