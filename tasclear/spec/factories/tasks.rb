FactoryBot.define do
  factory :task do
    sequence(:name) { |n| "タスク#{n}" }
    content '掃除、洗濯'
    deadline '2018-07-31'
    status 'to_do'
    priority 'low'
    user_id 1
  end
end
