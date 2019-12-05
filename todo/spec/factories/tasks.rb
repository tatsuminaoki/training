# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    title { 'テストタスク' }
    description { 'タスクの説明' }
    status { 0 }
    due_date { Time.zone.local(2100, 1, 1, 0, 0) }
    user
  end
end
