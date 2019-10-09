FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { Faker::Internet.password(min_length: 8) }

    trait 'with_tasks' do
      after(:create) do |user|
        create_list(:task, 3, user: user)
      end
    end
  end
end
