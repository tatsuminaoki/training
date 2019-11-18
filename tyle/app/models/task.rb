# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user

  has_many :task_labels, dependent: :destroy
  has_many :labels, through: :task_labels

  enum priority: %i[low medium high]
  enum status: %i[waiting in_progress done]

  validates :name, presence: true
  validates :user_id, presence: true
  validates :priority, presence: true
  validates :status, presence: true
  validates :due, presence: true

  scope :user_id, -> (user_id) { where(user_id: user_id) }
  scope :name_like, -> (name) { where('name like ?', "%#{name}%") if name.present? }
  scope :priority, -> (priority) { where(priority: priority) if priority.present? }
  scope :status, -> (status) { where(status: status) if status.present? }
end
