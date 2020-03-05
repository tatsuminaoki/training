FactoryBot.define do
  factory :task do
    name { 'test' }
    description { 'test' }
    priority { :high }
    end_period_at { Time.current + 2.days }
    creator_name { 'tester' }
    assignee_name { 'maganeer' }
  end
end
