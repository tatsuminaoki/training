FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "Task Title #{n}" }
    description 'Task Description'
    priority 'low'
    status 'waiting'
    due_date 1.day.since
    association :user, factory: :user
    factory :invalid_task do
      title nil
    end

    factory :newly_titled_task do
      title 'Updated Title'
    end
  end
end
