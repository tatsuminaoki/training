FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "TEST_TITLE#{n}"}
    sequence(:detail) { |n| "TEST_DETAIL#{n}"}
  end
end
