FactoryBot.define do
  factory :task do
    sequence(:task_name) { |n| "taskname#{n}" }
    description "description"
    deadline nil
    priority Task::PRIORITY_LOW
    status Task::STATUS_WAITING
    association :user
  end
end
