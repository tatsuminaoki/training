FactoryBot.define do
  factory :label_type do
    sequence(:label_name) { |n| "label_name#{n}"}
  end
end
