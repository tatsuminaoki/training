FactoryBot.define do
  factory :task do
    sequence(:name) { |n| "Task#{n}" }
    priority { 1 }
    status { 2 }
    endtime { Time.current }
    created_at { Time.current }
    association :user, factory: :user
  end
end