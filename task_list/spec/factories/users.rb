FactoryBot.define do
  factory :user do
    name { "user_name" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password_digest { "password" }
  end
end
