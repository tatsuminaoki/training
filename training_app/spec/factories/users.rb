# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  password   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#


FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "name #{n}" }
    password { "password" }
  end
end
