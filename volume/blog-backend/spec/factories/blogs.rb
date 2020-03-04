include ActionDispatch::TestProcess
FactoryBot.define do
  factory :blog do
    name { Faker::Name.name }
    is_private { Faker::Boolean.boolean }
    user_id { create(:user).id }

    trait :with_registred_user do
      user_id { create(:user, :registred).id }
    end

    trait :with_admin_user do
      user_id { create(:user, :admin).id }
    end

    trait :public do
      is_private { false }
    end

    trait :private do
      is_private { true }
    end
  end
end