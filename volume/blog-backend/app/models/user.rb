class User < ApplicationRecord
  has_secure_password
  validates :username, presence: true, uniqueness: true
  validates :password,
            length: { minimum: 3 }

  enum access_level: { registred: 0, admin: 1 }

  has_many :blogs, dependent: :destroy
  has_many :posts, dependent: :destroy

  def is_owner?(entity)
    entity.user == self
  end

  def has_access_level?
    registred? || admin?
  end

  def fields_string
    "User(id:#{id}, username:#{username}, accesslevel:#{access_level})"
  end
end
