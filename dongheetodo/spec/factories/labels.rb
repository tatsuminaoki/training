FactoryBot.define do
  factory :label do
    name { Faker::Food.fruits }
    color { Label.colors.keys.sample }
  end
end
