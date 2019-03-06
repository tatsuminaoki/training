class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  validates :priority, presence: true
  validates :status, presence: true
end
