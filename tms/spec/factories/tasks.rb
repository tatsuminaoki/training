FactoryBot.define do
  factory :task do
    title "Test Task 1"
    description "Setup development environment on localhost"
    due_date Date.current
    priority 0
    status 0
    user_id 1
    created_at Time.current
  end
end
