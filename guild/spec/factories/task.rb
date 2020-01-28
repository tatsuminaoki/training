FactoryBot.define do
  factory :task1, class: Task do
    id {1}
    user_id {1}
    subject {'test subject'}
    description {'test description'}
    state {1}
    priority {1}
    label {1}
  end
end
