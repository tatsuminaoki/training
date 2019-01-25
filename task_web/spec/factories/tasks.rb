FactoryBot.define do
  factory :task do
    sequence(:name) { |n| "Task Name #{n}" }
    description { '日用品を買い揃える' }
    due_date { '2018-12-12' }
    priority { :normal }
    association :user
    status { :open }
    sequence(:created_at) { |n| n.days.ago }
  end
end
