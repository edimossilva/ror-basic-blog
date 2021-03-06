require 'rails_helper'

RSpec.describe Post, type: :model do
  it { should validate_presence_of(:title) }

  it { should belong_to(:user) }

  it { should belong_to(:blog) }
end
