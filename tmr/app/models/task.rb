class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: TITLE_MAXIMUM_LENGTH = 20 }
  validates :user_id, presence: true
  validates :description, presence: true, length: { maximum: DESCRIPTION_MAXIMUM_LENGTH = 400 }
  validates :status, presence: true
  validates :priority, presence: true
end
