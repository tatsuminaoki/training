FactoryBot.define do
  factory :task do
    name { '買い物' }
    description { '日用品を買い揃える' }
    created_at { Time.now }
  end
end
