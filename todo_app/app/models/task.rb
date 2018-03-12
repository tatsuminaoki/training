class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 255 }
  validates :deadline, presence: true
  validates :status, presence: true
  validates :priority, presence: true
  validate :valid_datetime?

  enum status: Hash[%i[not_start progress done].map { |sym| [sym, sym.to_s] }].freeze
  enum priority: Hash[%i[low normal high quickly right_now].map { |sym| [sym, sym.to_s] }].freeze

  private

  def valid_datetime?
    errors.add(:deadline, I18n.t('errors.messages.invalid')) unless can_parse_datetime
  end

  def can_parse_datetime
    !! DateTime.parse(deadline.to_s) rescue false
  end
end
