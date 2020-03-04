class BlogAccessLevel
  def self.can_delete?(user, blog)
    return admin_can_delete?(user, blog) if user.admin?
    false
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new decoded
  end
  private

  def self.admin_can_delete?(user, blog)
    return true if blog.user_registred? 
    user.is_owner?(blog)
  end
end