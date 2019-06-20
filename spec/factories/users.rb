# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'test@test.com' }
    email_confirmation { 'test@test.com' }
    name { 'User Name' }
    role { :management }
  end
end
