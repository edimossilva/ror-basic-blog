include ActionDispatch::TestProcess
FactoryBot.define do
  factory :blog do
    name { Faker::Name.name }
    is_private { Faker::Boolean.boolean }
  end
end