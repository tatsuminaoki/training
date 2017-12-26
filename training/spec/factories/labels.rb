FactoryBot.define do
  factory :label do
    sequence :name do |n|
      "test_label_#{n}"
    end
  end
end
