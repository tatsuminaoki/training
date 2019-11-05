FactoryBot.define do
  factory :task do
    name { 'task1' }
    description { 'this is a task1' }
    priority { 0 }
    status { 0 }
    due { '20201231' }
  end 

  factory :task2, class: Task do
    name { 'task2' }
    description { 'this is a task2' }
    priority { 1 }
    status { 1 }
    due { '20210101' }
  end 

  factory :task3, class: Task do
    name { 'task3' }
    description { 'this is a task3' }
    priority { 2 }
    status { 2 }
    due { '20210102' }
  end
end 
