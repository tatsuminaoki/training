FactoryBot.define do
  factory :task do
    name '家事'
    content '掃除、洗濯'
    deadline '2018-07-31'
    status 'to_do'
    priority 'low'
  end
end
