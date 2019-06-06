# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    name { 'task name' }
    finished_on { Date.current }
  end
end
