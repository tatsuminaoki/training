# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user
  enum priority: %i[low medium high]
  enum status: %i[waiting in_progress done]

  validates :name, presence: true
  validates :user_id, presence: true
  validates :priority, presence: true
  validates :status, presence: true
end
