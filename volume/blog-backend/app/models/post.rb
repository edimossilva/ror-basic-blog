class Post < ApplicationRecord
  validates_presence_of :title
  belongs_to :blog  
  belongs_to :user
end
