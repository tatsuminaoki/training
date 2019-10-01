FactoryBot.define do
  factory :task do
    sequence(:name) { |n| "task#{n}" }
    description { Faker::Lorem.characters(number: 255) }
    status { Task.statuses.to_a.sample[0] }
    priority { Task.priorities.to_a.sample[0] }
    # 現在時刻から１ヶ月後の日時をランダムで付与
    duedate { rand(Time.now..(Time.now + 60 * 60 * 24 * 30)) }
    user
  end
end
