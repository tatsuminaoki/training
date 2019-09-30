FactoryBot.define do
  factory :task do
    sequence(:name) { |n| "task#{n}" }
    description { 'task description' }
    status { Task.statuses[:done] }
    priority { Task.priorities[:high] }
    user
  end
end
