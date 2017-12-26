FactoryBot.define do
  factory :user do
    name 'test_user'
    sequence :email do |n|
      "test#{n}@example.com"
    end
    password 'test1234'
    role User.roles[:normal]
  end
end
