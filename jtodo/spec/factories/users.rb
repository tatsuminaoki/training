FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user_test#{n}" }
    password 'userpass'
    is_admin false
    factory :user_with_tasks do
      after :create do |user|
        create_list :task, 2, user: user
      end
    end
  end
end
