FactoryBot.define do
  factory :task do
    sequence(:task_name) { |n| "task_name#{n}"}
    sequence(:description) { |n| "description#{n}"}
  end
end