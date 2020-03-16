class PostAccessLevel
  def self.can_create?(user, post)
    return can_user_create?(user, post) if user.has_access_level?
  end

  def self.can_delete?(user, post)
    return can_registred_delete?(user, post) if user.registred?
    return can_admin_delete?(user, post) if user.admin?
  end

  def self.can_user_create?(user, post)
    user.is_owner?(post) && user.is_owner?(post.blog)
  end

  def self.can_registred_delete?(user, post)
    user.is_owner?(post)
  end

  def self.can_admin_delete?(user, post)
    user.is_owner?(post) || post.user_registred?
  end
end
