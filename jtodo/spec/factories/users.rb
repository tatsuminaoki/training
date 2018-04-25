FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user_test #{n}" }
    password 'userpass'
    is_admin false
    factory :invalid_name do
      name nil
    end
    factory :invalid_password do
      password nil
    end
    factory :short_password do
      password 'short'
    end
  end
end
