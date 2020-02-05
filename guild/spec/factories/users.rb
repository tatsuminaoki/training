FactoryBot.define do
  factory :user1, class: User do
    name { 'rspec' }
    authority { 1 }
  end
end
