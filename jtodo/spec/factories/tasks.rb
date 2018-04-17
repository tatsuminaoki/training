FactoryBot.define do
  factory :task do
    title 'My Title'
    description 'MyDescription'
    priority 0
    status 0
    due_date '2018-04-16 14:55:42'
    factory :invalid_task do
      title nil
    end
    factory :newly_titled_task do
      title 'Updated Title'
    end
  end
end
