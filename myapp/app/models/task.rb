class Task < ApplicationRecord
  belongs_to :group

  validates :name, presence: true

  enum priority: { high: 0, middle: 1, low: 2 }
end
