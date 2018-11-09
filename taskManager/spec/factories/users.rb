FactoryBot.define do
  factory :user do
    sequence(:mail) { |n| "user#{n}@example.com" }
    sequence(:user_name) { |n| "user#{n}" }
    sequence(:password) { |n| "hogehoge#{n}" }
    sequence(:role) { User.roles.keys.sample }
  end
end
