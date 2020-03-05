class Post < ApplicationRecord
  validates :title, presence: true
  belongs_to :blog
  belongs_to :user

  delegate :admin?, to: :user, prefix: true
  delegate :registred?, to: :user, prefix: true
end
