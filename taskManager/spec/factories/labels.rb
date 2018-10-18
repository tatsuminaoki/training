FactoryBot.define do
  factory :label do
    sequence(:label_name) { |n| "label#{n}" }
  end
end
