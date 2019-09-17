# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    name { Faker::Name.name }
    detail { Faker::Lorem.sentence }
  end
end
