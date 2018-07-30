FactoryBot.define do
  factory :user do
    name '楽太郎'
    sequence(:email) { |n| "raku#{n}@example.com" }
    password 'password'
  end
end
