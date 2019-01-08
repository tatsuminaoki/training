FactoryBot.define do
  factory :task do
    name { '買い物' }
    description { '日用品を買い揃える' }
    due_date { '2018-12-12' }
    priority { :normal }
    user_id { 1 }
    status { :open }
    created_at { Time.now }
  end
end
