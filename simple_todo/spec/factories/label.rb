
FactoryBot.define do
  factory :label do
    sequence(:name) { |n| "test label #{n}"}
  end
end
