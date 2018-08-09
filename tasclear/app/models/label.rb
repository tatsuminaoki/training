# frozen_string_literal: true

class Label < ApplicationRecord
  validates :name, presence: true, length: { maximum: 10 }, uniqueness: true
  has_many :task_labels, dependent: :destroy
  has_many :tasks, through: :task_labels
end
