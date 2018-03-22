FactoryBot.define do
  factory :task do
    title 'Rspec test 0123'
    description 'This is a sample description'
    deadline '2018/03/01'
    status 'progress'
    priority 'high'
    association :user, factory: :user_association
  end

  factory :user_association, class: User do
    name 'task_user'
    password 'foobar'
    password_confirmation 'foobar'
  end
end
