class Task < ApplicationRecord
  belongs_to :user
  has_many :task_label, dependent: :destroy
  accepts_nested_attributes_for :task_label

  validates :task_name, presence: true
  validates :description, presence: true
  validates :user_id, presence: true
  validates :priority, presence: true
  validates :status, presence: true

  # TODO: enumを使うこと
  STATUS_WAITING = 0
  STATUS_WORKING = 1
  STATUS_COMPLETED = 2

  PRIORITY_LOW = 0
  PRIORITY_COMMON = 1
  PRIORITY_HIGH = 2


  # TODO: locate.yml使うこと
  TASK_STATUSES = {
    STATUS_WAITING => '未着手',
    STATUS_WORKING => '着手',
    STATUS_COMPLETED => '完了'
  }.freeze

  TASK_PRIORITIES = {
    PRIORITY_LOW => '低',
    PRIORITY_COMMON => '中',
    PRIORITY_HIGH => '高'
  }.freeze
end
