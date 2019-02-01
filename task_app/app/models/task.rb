# frozen_string_literal: true

class Task < ApplicationRecord
  enum priority: %i[low middle high].freeze
  enum status: %i[to_do in_progress done].freeze

  validates :name,        presence: true, length: { maximum: 30 }
  validates :description, presence: true, length: { maximum: 800 }
  validates :priority,    presence: true
  validates :status,      presence: true
  validate :validate_due_date

  def self.search(params)
    output = self
    output = output.where('name LIKE ?', "%#{params[:name]}%") if params[:name].present?
    output = output.where(status: params[:status]) if params[:status].present?
    output
  end

  private

  def validate_due_date
    errors.add(:due_date, :invalid) unless date_valid?(due_date)
  end

  def date_valid?(date)
    !!Date.parse(date.to_s)
  rescue TypeError, ArgumentError
    false
  end
end
