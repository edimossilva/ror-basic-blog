class BlogSerializer < ActiveModel::Serializer
  attributes :id
  attributes :name
  attributes :owner
  attributes :is_private

  has_many :posts

  def owner
    object.user.username
  end
end
