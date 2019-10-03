# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: User do
    sequence(:login_id) { |n| "User#{n}" }
    sequence(:password_digest) { |n| "Password#{n}" }
  end
end
