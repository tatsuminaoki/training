# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'test_user' }
    password { 'test_password' }
    password_confirmation { 'test_password' }
    role { :general }
  end

  factory :administrator, class: User do
    name { 'administrator' }
    password { 'admin_password' }
    password_confirmation { 'admin_password' }
    role { :admin }
  end
end
