# frozen_string_literal: true

class Task < ApplicationRecord
  enum priority: {
    low:    0,
    middle: 1,
    high:   2,
  }

  validates :name,        presence: true, length: { maximum: 30 }
  validates :description, presence: true, length: { maximum: 800 }
  validates :priority,    presence: true, inclusion: { in: self.priorities.keys }
  validate :validate_due_date

  private

  def validate_due_date
    errors.add(:due_date, :invalid) unless date_valid?(due_date)
  end

  def date_valid?(date)
    !!Date.parse(date.to_s)
  rescue
    false
  end
end
