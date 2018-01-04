FactoryBot.define do
  factory :task do
    name 'test_task'
    user
    description 'description'
    priority 0
    status Task.statuses[:not_started]
    label
    end_date Time.zone.today
  end
end
