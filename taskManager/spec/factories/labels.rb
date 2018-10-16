FactoryBot.define do
  factory :label do
    sequence(:id) { |n| n }
    sequence(:label_name) { |n| "label#{n}" }
  end
end
