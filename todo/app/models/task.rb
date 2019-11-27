# frozen_string_literal: true

class Task < ApplicationRecord
  validates :title, :status, presence: true
  validates :title, length: { maximum: 250 }
  validates :status, inclusion: { in: 0..2 }
  validate :due_date_cannot_be_in_past

  def due_date_cannot_be_in_past
    errors.add(:due_date, I18n.t('activerecord.errors.messages.past_time')) if due_date.present? && due_date < Time.zone.today
  end
end
