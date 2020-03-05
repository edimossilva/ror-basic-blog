include ActionDispatch::TestProcess
FactoryBot.define do
  factory :post do
    title { Faker::Books::CultureSeries.book }
    blog { create(:blog, :with_registred_user) }
    user_id { blog.user_id }

    trait :with_registred_user do
      blog { create(:blog, :with_registred_user) }
      user_id { blog.user_id }
    end

    trait :with_admin_user do
      blog { create(:blog, :with_admin_user) }
      user_id { blog.user_id }
    end

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
