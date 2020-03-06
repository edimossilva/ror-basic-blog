class Blog < ApplicationRecord
  validates :name, presence: true
  belongs_to :user
  has_many :posts, dependent: :destroy

  delegate :admin?, to: :user, prefix: true
  delegate :registred?, to: :user, prefix: true

  scope :only_public, -> { where('is_private = false') }
end
