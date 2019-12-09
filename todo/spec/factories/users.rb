# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'test_user' }
    password { 'test_password' }
    password_confirmation { 'test_password' }
  end
end
