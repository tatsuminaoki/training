FactoryBot.define do
  factory :task do
    title "Test Task 1"
    description "Setup development environment on localhost"
    due_date Time.zone.today
    priority 0
    status 0
    user_id 1
    created_at Time.now
  end
end
