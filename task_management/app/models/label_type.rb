class LabelType < ApplicationRecord
  has_many :labels, dependent: :destroy
  has_many :tasks, through: :labels

  validates :label_name, presence: true, length: {maximum: 255}, uniqueness: true
end
