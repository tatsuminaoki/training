FactoryBot.define do
  factory :task do
    name { '掃除' }
    description { 'トイレ,風呂' }
    due_date { '20190225' }
    priority { Task.priorities[:middle] }
    status { Task.statuses[:in_progress] }
    user
  end
end
