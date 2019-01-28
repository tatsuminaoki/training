# frozen_string_literal: true

class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  validates :description, presence: true, length: { maximum: 800 }
end
