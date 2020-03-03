class Task < ApplicationRecord
  belongs_to :group

  validates :name, presence: true
  validates :priority, presence: true
  validates :group_id, presence: true
  validate :verify_end_period_at

  enum priority: { high: 0, middle: 1, low: 2 }

  private

  def verify_end_period_at
  end
end
