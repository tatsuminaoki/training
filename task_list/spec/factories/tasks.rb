FactoryBot.define do
  factory :task do
    name { 'Math' }
    priority { 1 }
    status { 2 }
    endtime { Time.current }
    created_at { Time.current }
  end
end