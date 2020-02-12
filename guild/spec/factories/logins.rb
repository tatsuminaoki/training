# frozen_string_literal: true

FactoryBot.define do
  factory :login1, class: Login do
    user_id { 1 }
    email { 'test@example.com' }
    password { 'test' }
  end
end
