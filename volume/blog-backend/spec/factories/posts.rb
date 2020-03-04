include ActionDispatch::TestProcess
FactoryBot.define do
  factory :post do

    title { Faker::Books::CultureSeries.book }
    blog_id { create(:blog).id }
    user_id { create(:user).id }

    trait :without_title do
      title { nil }
    end

    trait :without_blog do
      blog_id { nil }
    end

    trait :without_user do
      user_id { nil }
    end
  end
end