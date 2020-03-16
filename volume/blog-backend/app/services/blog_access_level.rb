class BlogAccessLevel

  def self.can_show?(user, blog)
    return nonregistred_can_view?(blog) if user.nil?

    true
  end

  def self.nonregistred_can_view?(blog)
    !blog.is_private?
  end
end
