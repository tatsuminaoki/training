class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: TITLE_MAXIMUM_LENGTH = 20 }
  validates :user_id, presence: true
  validates :description, presence: true, length: { maximum: DESCRIPTION_MAXIMUM_LENGTH = 400 }
  validates :status, presence: true
  validates :priority, presence: true

  has_many :task_to_labels, dependent: :destroy
  has_many :labels, through: :task_to_labels

  belongs_to :user

  scope :get_by_user_id, ->(user_id) {
    where(user_id: user_id)
  }

  scope :get_by_status, ->(status) {
    where(status: status)
  }

  scope :get_by_keyword, ->(keyword) {
    where('title like :keyword OR description like :keyword', keyword: "%#{keyword}%")
  }
end
