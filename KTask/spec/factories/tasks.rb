# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "task#{n}" }
    content { 'Test Object' }
    priority { 'high' }
    status { 'do' }
    end_time { '2018-09-27' }
  end
end
