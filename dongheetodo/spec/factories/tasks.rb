FactoryBot.define do
  factory :task do
    sequence(:name) { |n| "task#{n}" }
    description { Faker::Lorem.characters(number: 255) }
    status { Task.statuses.keys.sample }
    priority { Task.priorities.keys.sample }
    # 現在時刻から１ヶ月後の日時をランダムで付与
    duedate { rand(Time.now..Time.now.since(30.days)) }
    created_at { rand(Time.now..Time.now.since(30.days)) }
    user
  end
end
