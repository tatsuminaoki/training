class Task < ApplicationRecord
  validates :title, presence: true
  validates :deadline, presence: true
  validates :status, presence: true
  validates :priority, presence: true

  enum status: Hash[%i[not_start progress done].map { |sym| [sym, sym.to_s] }].freeze
  enum priority: Hash[%i[low normal high quickly right_now].map { |sym| [sym, sym.to_s] }].freeze
end
