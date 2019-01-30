# frozen_string_literal: true

class Task < ApplicationRecord
  enum priority: %i[low middle high].freeze

  validates :name,        presence: true, length: { maximum: 30 }
  validates :description, presence: true, length: { maximum: 800 }
  validates :priority,    presence: true
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
