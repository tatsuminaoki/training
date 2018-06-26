FactoryBot.define do
  factory :task do
    sequence(:task_name) { |n| "task_name#{n}"}
    sequence(:description) { |n| "description#{n}"}
    sequence(:due_date) { |n| Date.today + n }
  end
end
