# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'MyString' }
    password { 'password' }
    account { 'tadashi.toyokura' }
    role { 0 }

    factory :user_with_tasks do
      transient do
        tasks_count { 1 }
        name { 'aaaa' }
        description { '' }
        status { 'todo' }
        deadline { Time.zone.today.to_s }
      end

      after(:create) do |user, evaluator|
        create_list(:task,
                    evaluator.tasks_count,
                    user: user,
                    name: evaluator.name,
                    description: evaluator.description,
                    status: evaluator.status,
                    deadline: evaluator.deadline)
      end
    end
  end
end
