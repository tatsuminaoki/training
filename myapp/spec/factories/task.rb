FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "hogehoge#{n}" }
    memo { 'hugahuga' }
  end
end
