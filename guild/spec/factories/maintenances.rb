# frozen_string_literal: true

FactoryBot.define do
  factory :maintenance1, class: Maintenance do
    start_at { Time.now }
    end_at { Time.now.tomorrow }
  end
end
