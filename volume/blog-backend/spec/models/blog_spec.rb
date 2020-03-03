require 'rails_helper'

RSpec.describe Blog, type: :model do
  it "is invalid when blog is empty" do
    expect(Blog.new).to be_invalid
  end
end
