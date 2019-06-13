class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validates :detail, presence: true, length: { maximum: 255 }
end
