class PostPolicy
  attr_reader :user, :post

  def initialize(user, post)
    @user = user
    @post = post
  end

  def create?
    return can_user_create? if user.has_access_level?
  end

  def destroy?
    return can_registred_delete? if user.registred?
    return can_admin_delete? if user.admin?
  end

  def show?
    return post.public? if user.nil?

    true
  end

  private

  def can_registred_delete?
    user.is_owner?(post)
  end

  def can_admin_delete?
    user.is_owner?(post) || post.user_registred?
  end

  def can_user_create?
    user.is_owner?(post) && user.is_owner?(post.blog)
  end
end
