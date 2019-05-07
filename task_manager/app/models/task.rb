# frozen_string_literal: true

class Task < ApplicationRecord
  extend Enumerize
  enumerize :status, in: { new: 0, wip: 1, done: 2, pending: 3 }
  validates :name, presence: true, length: { maximum: 64 }
  validates :status, presence: true

  validate :due_date_cannot_be_in_the_past

  scope :search_by_status, -> (status) { where(status: status) }

  def self.ransackable_scopes(_auth_object = nil)
    %i[search_by_status]
  end

  def due_date_cannot_be_in_the_past
    errors.add(:due_date, I18n.t('errors.messages.past_days')) if due_date.present? && due_date.past?
  end
end
