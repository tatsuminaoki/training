class Task < ApplicationRecord
  enum status: { 'open': 1, 'inprogress': 2, 'review': 3, 'reopen': 4, 'done': 5 }
  enum priority: { 'highest': 1, 'higher': 2, 'middle': 3, 'lower': 4, 'lowest': 5 }

  MAX_LENGTH_SUMMARY = 50
  MAX_LENGTH_DESCRIPTION = 255

  validates :summary,
    presence: true,
    length: { maximum: MAX_LENGTH_SUMMARY }

  validates :description,
    length: { maximum: MAX_LENGTH_DESCRIPTION }

  validates :priority,
    presence: true

  validates :status,
    presence: true

end
