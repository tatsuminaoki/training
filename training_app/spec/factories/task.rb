FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "title #{n}"}
    sequence(:body) { |n| "body #{n}"}

    status { 0 }
  end
end
