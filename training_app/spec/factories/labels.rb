# frozen_string_literal: true

# == Schema Information
#
# Table name: tasks
#
#  id         :bigint           not null, primary key
#  body       :text(65535)      not null
#  status     :integer          default("todo"), not null
#  title      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#
# Indexes
#
#  index_tasks_on_status   (status)
#  index_tasks_on_user_id  (user_id)
#


FactoryBot.define do
  factory :label do
    sequence(:name) { |n| "label_#{n}"}
  end
end
