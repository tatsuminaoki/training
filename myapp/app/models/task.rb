class Task < ApplicationRecord
  enum priority: {Low: 0, Middle: 1, High: 2}
  enum status: {Open: 0, InProgress: 1, Closed: 2}

  validates :title,
    presence: true,
    length: { maximum: 255 }

  validates :description,
    length: { maximum: 512 }

  validates :priority,
    presence: true

  validates :status,
    presence: true
end
