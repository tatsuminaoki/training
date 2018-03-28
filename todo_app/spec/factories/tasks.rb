FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "Rspec test #{n}" }
    description 'This is a sample description'
    sequence(:deadline) { |n| Time.now.getlocal + n }
    status 'progress'
    priority 'high'
    sequence(:created_at) { |n| Time.now.getlocal + n }
    association :user, factory: :user
  end
end
