# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user

  enum priority: %i[low middle high].freeze
  enum status: %i[to_do in_progress done].freeze

  validates :name,        presence: true, length: { maximum: 30 }
  validates :description, presence: true, length: { maximum: 800 }
  validates :priority,    presence: true
  validates :status,      presence: true
  validate :validate_due_date

  # 検索は渡されたレコード、または1から行う
  def self.search(params, initial_records = nil)
    initial_records ||= self
    initial_records   = initial_records.where('name LIKE ?', "%#{params[:name]}%") if params[:name].present?
    initial_records   = initial_records.where(status: params[:status]) if params[:status].present?
    initial_records
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
