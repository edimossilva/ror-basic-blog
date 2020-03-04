class PostAccessLevel
  def self.can_create?(user, post)
    return can_user_create?(user, post) if user.has_access_level? 
  end

  private

  def self.can_user_create?(user, post)
    user.is_owner?(post) && user.is_owner?(post.blog)
  end
end