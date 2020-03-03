require 'rails_helper'

RSpec.describe Blog, type: :model do
  let!(:complete_blog) { build :blog }

  it "is valid when blog has name" do
    expect(complete_blog).to be_valid
  end

  it "is invalid when blog has no name" do
    expect(Blog.new).to be_invalid
  end
end
