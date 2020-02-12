# frozen_string_literal: true

FactoryBot.define do
  factory :task1, class: Task do
    user_id { 1 }
    subject { 'test subject 1st' }
    description { 'test description' }
    state { 1 }
    priority { 1 }
    label { 1 }
  end
end
