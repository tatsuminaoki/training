FactoryBot.define do
  factory :task do
    name { '買い物' }
    description { '日用品を買い揃える' }
    due_date { '2018-12-12' }
    priority { 0 }
    user_id { 1 }
    created_at { Time.now }
  end
end
