# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :group

  validates :name, presence: true
  validates :priority, presence: true
  validates :group_id, presence: true
  validate :verify_end_period_at

  enum priority: { high: 0, middle: 1, low: 2 }

  private

  def verify_end_period_at
    return if end_period_at.blank? || Time.current.strftime('%Y/%m/%d') <= end_period_at.strftime('%Y/%m/%d')

    errors.add(:end_period_at, I18n.t('validate.errors.tasks.end_period_at_is_old_than_current'))
  end
end
