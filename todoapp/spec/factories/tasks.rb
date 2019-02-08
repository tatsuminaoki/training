FactoryBot.define do
  factory :task do
    title { 'テストを書く' }
    description { 'RSpec＆Capybara＆FactoryBotを準備する' }
    status { 1 }
    end_at { '2100-01-01' }
    user

    trait :first_task do
      title { '最初のタスク' }
      status { 'working' }
      end_at { '2100-10-10 00:10:00' }
      created_at { '2010-10-10 00:10:00' }
    end

    trait :second_task do
      title { '2つ目のタスク' }
      status { 'completed' }
      end_at { '2100-10-10 00:10:01' }
      created_at { '2010-10-10 00:10:01' }
    end

    trait :third_task do
      title { '3つ目のタスク' }
      status { 'working' }
      end_at { nil }
      created_at { '2010-10-10 00:10:02' }
    end
  end
end
