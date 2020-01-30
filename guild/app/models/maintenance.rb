class Maintenance < ApplicationRecord
  validates :start_at, presence: true
  validates :end_at, presence: true
  validate :start_end_check

  def start_end_check
    unless start_at.nil? || end_at.nil?
      errors.add(:end_at, 'Invalid value') unless self.start_at < self.end_at
    end
  end
end
