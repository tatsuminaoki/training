# frozen_string_literal: true

class Task < ApplicationRecord
  validates :title, :status, presence: true
  validates :title, length: { maximum: 250 }
  validates :status, inclusion: { in: 0..2 }
end
