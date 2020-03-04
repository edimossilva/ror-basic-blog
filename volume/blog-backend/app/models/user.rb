class User < ApplicationRecord
  has_secure_password
  validates :username, presence: true, uniqueness: true
  validates :password,
            length: { minimum: 3 }
  
  enum access_level: [:registred, :admin]
  
  has_many :blogs, dependent: :destroy
end