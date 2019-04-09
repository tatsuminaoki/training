FactoryBot.define do
  factory :label do
    name { 'test' }
    association :user, factory: :user
  end
end
