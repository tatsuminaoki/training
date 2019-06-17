FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "NAME_#{n}" }
  end
end
