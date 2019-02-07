# frozen_string_literal: true

class Label < ApplicationRecord
  has_many :task_labels, dependent: :destroy
  has_many :tasks, through: :task_labels
  validates :name, presence: true, uniqueness: true, length: { maximum: 10 }
end
