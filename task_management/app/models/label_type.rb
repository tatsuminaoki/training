class LabelType < ApplicationRecord
  has_many :labels
  has_many :tasks, through: :labels

  validates :label_name, presence: true, length: {maximum: 255}
end
