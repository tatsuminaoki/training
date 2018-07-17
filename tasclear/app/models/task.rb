# frozen_string_literal: true

class Task < ApplicationRecord
  validates :name,
    presence: true,
    length: { maximum: 20 }
  validates :content, length: { maximum: 200 }
end
