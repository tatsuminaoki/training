class Label < ApplicationRecord
  has_many :task_label, dependent: :destroy

  validates :label_name, presence: true
  validates :label_name, uniqueness: true
end
