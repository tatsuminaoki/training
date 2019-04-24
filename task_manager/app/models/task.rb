# frozen_string_literal: true

class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 64 }
  validate :due_date_cannot_be_in_the_past

  def due_date_cannot_be_in_the_past
    if due_date.present? && due_date.past?
      errors.add(:due_date, I18n.t('errors.messages.in_the_future'))
    end
  end
end
