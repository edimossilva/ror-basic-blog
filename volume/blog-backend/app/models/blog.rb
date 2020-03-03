class Blog < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :is_private
end
