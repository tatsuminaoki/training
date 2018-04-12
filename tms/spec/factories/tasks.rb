FactoryBot.define do
  factory :task do
    title "Setup DEV ENV"
    description "Setup development environment on localhost"
    due_date "2018-04-17"
    priority 0    
    status 0    
    user_id 1
  end
end
