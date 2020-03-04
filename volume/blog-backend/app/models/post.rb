class Post < ApplicationRecord
  validates_presence_of :title
  belongs_to :blog  
  belongs_to :user
  
  delegate :admin?, to: :user, prefix: true
  delegate :registred?, to: :user, prefix: true
end
