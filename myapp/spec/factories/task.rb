FactoryBot.define do
  factory :task do
    name { 'test task name' }
    description { 'test task description' }
    priority { :high }
  end
end
