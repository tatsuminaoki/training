FactoryBot.define do
  factory :task do
    sequence(:task_name) { |n| "taskname#{n}" }
    sequence(:description) { |n| "description#{n}" }
    deadline nil
    priority :low
    status :waiting
    association :user
  end
end
