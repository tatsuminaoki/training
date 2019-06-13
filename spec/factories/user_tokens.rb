# frozen_string_literal: true

FactoryBot.define do
  factory :user_token do
    association(:user)
  end
end

