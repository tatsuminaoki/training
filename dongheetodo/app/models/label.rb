class Label < ApplicationRecord
  has_many :task_labels
  has_many :tasks, through: :task_labels

  enum color: [:red, :orange, :yellow, :green, :blue, :indigo, :violet, :black]

  validates :name, presence: true, uniqueness: true, length: { maximum: 255 }
  validates :color, presence: true, inclusion: { in: Label.colors.keys }
end
