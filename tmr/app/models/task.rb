class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: TITLE_MAXIMUM_LENGTH = 20 }
  validates :user_id, presence: true
  validates :description, presence: true, length: { maximum: DESCRIPTION_MAXIMUM_LENGTH = 400 }
  validates :status, presence: true
  validates :priority, presence: true

  belongs_to :user

  scope :get_by_status, ->(status) {
    if status != '0'
      where(status: status)
    end
  }

  scope :get_by_keyword, ->(keyword) {
    where('title like :keyword OR description like :keyword', keyword: "%#{keyword}%")
  }
end
