# frozen_string_literal: true

class Task < ApplicationRecord
  extend Enumerize
  enumerize :status, in: { new: 0, wip: 1, done: 2, pending: 3 }

  validates :name, presence: true, length: { maximum: 64 }
  validate :due_date_cannot_be_in_the_past

  def due_date_cannot_be_in_the_past
    errors.add(:due_date, I18n.t('errors.messages.past_days')) if due_date.present? && due_date.past?
  end
end
