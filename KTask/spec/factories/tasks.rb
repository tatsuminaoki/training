# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    title { 'This is a Robot' }
    content { 'Test Object' }
    status { 'do' }
    end_time { '2018-09-27' }
  end
end
