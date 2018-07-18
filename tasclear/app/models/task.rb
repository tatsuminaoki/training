# frozen_string_literal: true

class Task < ApplicationRecord
  validates :name,
    presence: true,
    length: { maximum: 20 }
  validates :content, length: { maximum: 200 }
  enum status: { to_do: 0, doing: 1, done: 2 }
end
