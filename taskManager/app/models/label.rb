class Label < ApplicationRecord
  has_many :task_label, dependent: :destroy

  validates :label_name,
            presence: true,
            uniqueness: true,
            length: { maximum: 255 }
end
