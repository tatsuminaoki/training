FactoryBot.define do
  factory :task do
    title       { 'Task' }
    description { 'Description' }
  end

  factory :task1, class: Task do
    title       { 'Task1' }
    description { 'Description1' }
  end

  factory :task2, class: Task do
    title       { 'Task2' }
    description { 'Description2' }
  end

  factory :task3, class: Task do
    title       { '' }
    description { '' }
  end
end
