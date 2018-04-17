class Task < ApplicationRecord
  validates :title,     presence: true, length: { maximum: 255 }
  validates :status,    inclusion: { in: 0..2 }
  validates :priority,  inclusion: { in: 0..2 }
end
