FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "task #{n}"}
    body { "this is the body of #{title}. It can contain a very long words since it is a text fields" }
    task_limit { [1, 2, 3].sample.month.from_now }
    aasm_state { ['not_yet', 'on_going', 'done'].sample }
  end
end