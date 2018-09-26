# frozen_string_literal: true

class Task < ApplicationRecord
  enum status: %i[yet do done]
  validates :title, presence: true, length: { maximum: 20 }
  validates :content, presence: true, length: { maximum: 255 }
  validates :status, presence: true
end
