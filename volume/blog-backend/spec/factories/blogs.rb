include ActionDispatch::TestProcess
FactoryBot.define do
  factory :blog do
    name { "mock_blog_name" }
    is_private { false }
  end
end