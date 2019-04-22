FactoryBot.define do
  factory :task do
    sequence(:name) { |n| "name_#{n}" }
    sequence(:content) { |n| "dummy content_#{n}" }
    sequence(:status) { 0 }
  end
end
