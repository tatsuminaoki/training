FactoryBot.define do
  factory :task do
    title 'Rspec test 0123'
    description 'This is a sample description'
    deadline '2018/03/01'
    status 'progress'
    priority 'high'
    association :user, factory: :user
  end
end
