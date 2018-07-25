class LabelType < ApplicationRecord
  has_many :tasks, through: :labels
  has_many :labels

  validates :label_name, presence: true, length: {maximum: 255}
end
