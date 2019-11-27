# frozen_string_literal: true

FactoryBot.define do
  factory :task_label do
    label
    task
  end
end
