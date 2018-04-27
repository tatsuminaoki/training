FactoryBot.define do

  factory :task_attributes, class: Hash do
    user_id 1
    sequence(:title) { |n| "Test title#{n}" }
    sequence(:description) { |n| "Test description#{n}" }
    status 1
    priority 20
    due_date Faker::Time.between(Date.today, 5.days.from_now)
    start_date Faker::Time.between(10.days.ago, 5.days.ago)
    finished_date Faker::Time.between(4.days.ago, Date.today)

    initialize_with { attributes }
  end

  factory :task do
    user_id 1
    sequence(:title) { |n| "Test title#{n}" }
    sequence(:description) { |n| "Test description#{n}" }
    status 1
    priority 20
    due_date Faker::Time.between(Date.today, 5.days.from_now)
    start_date Faker::Time.between(10.days.ago, 5.days.ago)
    finished_date Faker::Time.between(4.days.ago, Date.today)
  end


end
