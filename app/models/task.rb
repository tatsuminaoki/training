# frozen_string_literal: true

class Task < ApplicationRecord
  enum status: { waiting: 1, work_in_progress: 2, completed: 3 }

  validates :name, presence: true, length: { maximum: 20 }
  validates :finished_on, presence: true

  validate :validates_past_date_not_allowed, if: -> { finished_on.present? }

  scope :name_like, -> (name) { where('name like ?', "%#{name}%") if name.present? }
  scope :status, -> (status) { where(status: status) if status.present? }

  def validates_past_date_not_allowed
    errors.add(:finished_on, I18n.t('errors.messages.past_days')) if finished_on.past?
  end
end
