FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "TEST_TITLE#{n}" }
    sequence(:detail) { |n| "TEST_DETAIL#{n}" }
    status { ['todo', 'doing', 'done'].sample }
  end
end
