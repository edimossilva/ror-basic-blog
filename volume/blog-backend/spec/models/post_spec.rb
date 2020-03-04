require 'rails_helper'

RSpec.describe Post, type: :model do
  let!(:post) { build :post }
  let!(:post_without_title) { build :post, :without_title }
  let!(:post_without_blog) { build :post, :without_blog }
  
  it "is valid when post has all valid fields" do
    expect(post).to be_valid
  end

  context 'when post is invalid' do
    it "is invalid when post has no title" do
      expect(post_without_title).to be_invalid
    end
    it "is invalid when post has no blog" do
      expect(post_without_blog).to be_invalid
    end
  end
end
