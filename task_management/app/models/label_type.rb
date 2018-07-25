class LabelType < ApplicationRecord
  has_many :labels, foreign_key: 'label_type_id'
  has_many :tasks, through: :labels

  validates :label_name, presence: true, length: {maximum: 255}
end
