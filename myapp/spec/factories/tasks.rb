# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    name { 'John' }
    user
  end
end
