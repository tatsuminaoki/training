# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    title { 'テスト' }
    description { 'テストです' }
    priority { 10 }
    status { 10 }
  end
end
