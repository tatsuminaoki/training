FactoryBot.define do
  factory :task do
    title 'My Title'
    description 'MyDescription'
    priority 'low'
    status 'waiting'
    due_date 1.day.since

    factory :invalid_task do
      title nil
    end

    factory :newly_titled_task do
      title 'Updated Title'
    end
  end
end
