class PostPolicy
  attr_reader :user, :post

  def initialize(user, post)
    @user = user
    @post = post
  end

  def show?
    return post.public? if user.nil?

    true
  end
end
