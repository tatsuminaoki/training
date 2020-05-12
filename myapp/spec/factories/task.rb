FactoryBot.define do
  factory :task do
    title { 'hoge' }
    memo { 'hugahuga' }
  end
  factory :task1, class: Task do
    title { 'test1' }
    memo { 'testtest1' }
  end
  factory :task2, class: Task do
    title { 'test2' }
    memo { 'testtest2' }
  end
  factory :task3, class: Task do
    title { 'test3' }
    memo { 'testtest3' }
  end
  factory :task4, class: Task do
    title { 'test4' }
    memo { 'testtest4' }
  end
end
