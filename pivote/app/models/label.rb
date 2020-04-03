# frozen_string_literal: true

class Label < ApplicationRecord
  validates :name, presence: true, uniqueness: true, length: { maximum: 15 }

  belongs_to :user
  has_many :task_labels, dependent: :destroy
  has_many :tasks, :through => :task_labels
end
