class Label < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }, uniqueness: true
end
