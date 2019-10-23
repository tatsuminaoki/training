FactoryBot.define do
  sequence :task_title do |i|
    "Test Task #{i}"
  end

  factory :task do
    title { generate :task_title }
    description { 'This is a test task.' }
    user_id { 1 }
    priority { 0 }
    status { 0 }
    due_date { '2019-10-20' }
  end
end
