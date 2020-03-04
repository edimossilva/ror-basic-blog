class Blog < ApplicationRecord
  validates_presence_of :name
  belongs_to :user
  has_many :posts, dependent: :destroy

  delegate :admin?, to: :user, prefix: true
  delegate :registred?, to: :user, prefix: true
end
