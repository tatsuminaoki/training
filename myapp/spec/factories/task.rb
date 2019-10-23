FactoryBot.define do
  factory :task1, class: Task do
    title { 'Test Task 1' }
    description { 'This is a test task.' }
    user_id { 1 }
    priority { 0 }
    status { 0 }
    due_date { '2019-10-20' }
  end

  factory :task2, class: Task do
    title { 'Test Task 2' }
    user_id { 1 }
    priority { 0 }
    status { 0 }
  end

  factory :task3, class: Task do
    title { 'Test Task 3' }
    user_id { 1 }
    priority { 0 }
    status { 0 }
  end
end