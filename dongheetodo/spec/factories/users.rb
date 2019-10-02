FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password_digest { 'hoge' }

    trait 'with_tasks' do
      after(:create) do |user|
        create_list(:task, 3, user: user)
      end
    end
  end
end
