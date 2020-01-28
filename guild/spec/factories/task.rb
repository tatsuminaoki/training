FactoryBot.define do
  factory :task1, class: Task do
    id {1}
    user_id {1}
    subject {'test subject 1st'}
    description {'test description'}
    state {1}
    priority {1}
    label {1}
  end
  factory :task2, class: Task do
    id {2}
    user_id {1}
    subject {'test subject 2nd'}
    description {'test description 2nd'}
    state {2}
    priority {2}
    label {2}
  end
  factory :task_new, class: Task do
    id {3}
    user_id {1}
    subject {'new test subject'}
    description {'new test description'}
    state {1}
    priority {3}
    label {3}
    created_at {Time.current.tomorrow}
    updated_at {Time.current.tomorrow}
  end
end
