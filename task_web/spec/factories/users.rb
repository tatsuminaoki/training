FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:name) { |n| "User Name #{n}" }
    sequence(:password) { |n| "rakuten#{n}" }
    auth_level { :normal }
  end
end
