FactoryBot.define do
  factory :label do
    sequence(:id) { |n| "#{n}" }
    sequence(:name) { |n| "label#{n}" }
  end
end
