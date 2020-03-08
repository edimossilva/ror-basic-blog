class PostSerializer < ActiveModel::Serializer
  attributes :id
  attributes :title
  attributes :owner
  attributes :is_private
  attributes :blog_id
  attributes :user_id

  def owner
    object.user.username
  end

  def is_private
    object.blog.is_private
  end
end
