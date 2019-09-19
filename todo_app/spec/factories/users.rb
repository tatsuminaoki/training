# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { 'hoge@hoge.com' }
    password { 'password' }
  end
end
