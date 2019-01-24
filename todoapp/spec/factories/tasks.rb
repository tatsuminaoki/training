FactoryBot.define do
  factory :task do
    title { 'テストを書く' }
    description { 'RSpec＆Capybara＆FactoryBotを準備する' }
    status { 1 }
    end_at { '2010-01-01' }
    user
  end
end
