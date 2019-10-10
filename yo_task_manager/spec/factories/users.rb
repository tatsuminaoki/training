# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:login_id) { |n| "user_#{n}" }
    password { 'dummy1234' }
    display_name { "#{login_id}の名前" }
  end
end
