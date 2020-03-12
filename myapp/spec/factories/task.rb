FactoryBot.define do
  factory :task do
    name { 'test' }
    description { 'test' }
    priority { :high }
  end
end
