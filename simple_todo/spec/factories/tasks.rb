FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "test title #{n}"}
    sequence(:description) { |n| "description#{n}"}
    user_id {1}
    sequence(:limit) { |n| Date.today + n }
    priority {1}
    status {1}  
  end
end
