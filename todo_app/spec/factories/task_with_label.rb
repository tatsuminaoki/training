FactoryBot.define do
  factory :task_with_label, class: Task do
    sequence(:title) { |n| "Rspec test #{n}" }
    description 'This is a sample description'
    sequence(:deadline) { |n| Time.now.getlocal + n }
    status 'progress'
    priority 'high'
    sequence(:label_list) { |n| "label#{n}" }
    sequence(:created_at) { |n| Time.now.getlocal + n }
    association :user, factory: :user
  end
end
