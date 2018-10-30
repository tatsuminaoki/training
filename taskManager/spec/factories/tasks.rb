FactoryBot.define do
  factory :task do
    sequence(:task_name) { |n| "taskname#{n}" }
    sequence(:description) { |n| "description#{n}" }
    deadline { rand(1..1000).days.from_now }
    sequence(:priority) { Task.priorities.keys.sample }
    sequence(:status) { Task.statuses.keys.sample }
    association :user
    sequence(:created_at) { |n| Time.now + ((n - 1) * 1000).days }
    updated_at Time.now
  end
end
