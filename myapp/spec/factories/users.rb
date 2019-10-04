# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: User do
    sequence(:login_id) { |n| "TestUser#{n}" }
    sequence(:password) { |_n| 'TestPassword123' }
    sequence(:password_confirmation) { |_n| 'TestPassword123' }
  end
end
