FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user_test #{n}" }
    password 'userpass'
    is_admin false
  end
end
